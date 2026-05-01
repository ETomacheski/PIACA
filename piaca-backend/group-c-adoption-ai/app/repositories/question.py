from datetime import date
from uuid import UUID, uuid4

from fastapi import Depends
from sqlalchemy.orm import Session

from app.dependencies.database import piaca_db
from app.models.question import QuestionnaireResponse
from app.models.user import User


class QuestionRepository:
    def __init__(
        self,
        session: Session,
    ):
        self.session = session

    def create_question(self) -> dict[str, object]:
        today = date.today()
        user = piaca_db.add(
            self.session,
            User(
                email=f"mock-questionnaire-{uuid4()}@example.com",
                password_hash="mock-password-hash",
                status=1,
                created_at=today,
                updated_at=today,
            ),
        )
        questionnaire_response = piaca_db.add(
            self.session,
            QuestionnaireResponse(
                family_size=3,
                routine="mock routine",
                user_id=user.id,
                created_at=today,
                updated_at=today,
            ),
        )

        return self._to_dict(questionnaire_response)

    def get_question(self, question_id: UUID) -> dict[str, object] | None:
        question = piaca_db.get_by_id(
            self.session,
            QuestionnaireResponse,
            question_id,
        )
        if question is None:
            return None

        return self._to_dict(question)

    def delete_question(self, question_id: UUID) -> bool:
        return piaca_db.delete_by_id(
            self.session,
            QuestionnaireResponse,
            question_id,
        )

    def update_question(self, question_id: UUID) -> dict[str, object] | None:
        today = date.today()
        question = piaca_db.update_by_id(
            self.session,
            QuestionnaireResponse,
            question_id,
            {
                "family_size": 4,
                "routine": "updated mock routine",
                "updated_at": today,
            },
        )
        if question is None:
            return None

        return self._to_dict(question)

    def _to_dict(self, question: QuestionnaireResponse) -> dict[str, object]:
        return {
            "id": str(question.id),
            "family_size": question.family_size,
            "routine": question.routine,
            "user_id": str(question.user_id),
            "createdAt": question.created_at.isoformat()
            if question.created_at is not None
            else None,
            "updatedAt": question.updated_at.isoformat()
            if question.updated_at is not None
            else None,
        }


def get_question_repo(
    session: Session = Depends(piaca_db.get_session),
) -> QuestionRepository:
    return QuestionRepository(session=session)
