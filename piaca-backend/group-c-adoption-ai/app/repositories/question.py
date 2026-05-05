import json
from datetime import date, datetime, time
from uuid import UUID

from fastapi import Depends
from sqlalchemy import func
from sqlalchemy import update as sql_update
from sqlalchemy.orm import Session

from app.dependencies.database import piaca_db
from app.models.questions import Question
from app.schemas.questions import CreateQuestionRequest
from app.schemas.shared.responses import (
    CreatedResponse,
    DataResponse,
    DeletedResponse,
    UpdatedResponse,
)


class QuestionRepository:
    def __init__(
        self,
        session: Session,
    ):
        self.session = session

    def create_question(self, data: CreateQuestionRequest) -> CreatedResponse:
        possible_answers = (
            json.dumps([opt.model_dump() for opt in data.possible_answers])
            if data.possible_answers
            else None
        )
        question = piaca_db.add(
            self.session,
            Question(
                code=self._next_code(),
                text=data.question,
                possible_answers=possible_answers,
                type=data.type.value,
                created_at=data.created_at,
                updated_at=data.updated_at,
            ),
        )

        return CreatedResponse(
            id=question.id,
            created_at=self._to_datetime(question.created_at),
            function_response=self._to_dict(question),
        )

    def reorder_question(
        self, question_id: UUID, new_code: int
    ) -> UpdatedResponse | None:
        question = self.session.get(Question, question_id)
        if question is None:
            return None

        old_code = question.code
        if old_code is None:
            raise ValueError("Question has no code assigned and cannot be reordered")

        max_code = self._max_code()

        # clamp new_code to valid range [1, max_code]
        new_code = max(1, min(new_code, max_code))

        if old_code == new_code:
            return UpdatedResponse(
                id=question.id,
                updated_at=self._to_datetime(question.updated_at),
                function_response=self._to_dict(question),
            )

        if new_code > old_code:
            # moving down: shift questions in (old_code, new_code] up by -1
            self.session.execute(
                sql_update(Question)
                .where(Question.id != question_id)
                .where(Question.code > old_code)
                .where(Question.code <= new_code)
                .values(code=Question.code - 1)
            )
        else:
            # moving up: shift questions in [new_code, old_code) down by +1
            self.session.execute(
                sql_update(Question)
                .where(Question.id != question_id)
                .where(Question.code >= new_code)
                .where(Question.code < old_code)
                .values(code=Question.code + 1)
            )

        self.session.flush()
        question.code = new_code
        question.updated_at = date.today()
        self.session.commit()
        self.session.refresh(question)

        return UpdatedResponse(
            id=question.id,
            updated_at=self._to_datetime(question.updated_at),
            function_response=self._to_dict(question),
        )

    def get_question(self, question_id: UUID) -> DataResponse[dict] | None:
        question = piaca_db.get_by_id(
            self.session,
            Question,
            question_id,
        )
        if question is None:
            return None

        return DataResponse(data=self._to_dict(question))

    def delete_question(self, question_id: UUID) -> DeletedResponse:
        deleted = piaca_db.delete_by_id(
            self.session,
            Question,
            question_id,
        )

        return DeletedResponse(id=question_id, deleted=deleted)

    def update_question(self, question_id: UUID) -> UpdatedResponse | None:
        today = date.today()
        question = piaca_db.update_by_id(
            self.session,
            Question,
            question_id,
            {
                "text": "updated mock question text",
                "updated_at": today,
            },
        )
        if question is None:
            return None

        return UpdatedResponse(
            id=question.id,
            updated_at=self._to_datetime(question.updated_at),
            function_response=self._to_dict(question),
        )

    def _to_dict(self, question: Question) -> dict[str, object]:
        return {
            "id": str(question.id),
            "code": question.code,
            "text": question.text,
            "possible_answers": question.possible_answers,
            "type": question.type,
            "createdAt": question.created_at.isoformat()
            if question.created_at is not None
            else None,
            "updatedAt": question.updated_at.isoformat()
            if question.updated_at is not None
            else None,
        }

    def _max_code(self) -> int:
        return self.session.query(func.max(Question.code)).scalar() or 0

    def _next_code(self) -> int:
        return self._max_code() + 1

    def _to_datetime(self, value: date | None) -> datetime:
        if value is None:
            return datetime.now()
        return datetime.combine(value, time())


def get_question_repo(
    session: Session = Depends(piaca_db.get_session),
) -> QuestionRepository:
    return QuestionRepository(session=session)
