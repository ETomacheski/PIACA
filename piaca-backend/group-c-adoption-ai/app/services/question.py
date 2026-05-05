from uuid import UUID

from fastapi import Depends

from app.repositories.question import QuestionRepository, get_question_repo
from app.schemas.questions import CreateQuestionRequest
from app.schemas.shared.responses import (
    CreatedResponse,
    DataResponse,
    DeletedResponse,
    UpdatedResponse,
)


class QuestionService:
    def __init__(self, repo: QuestionRepository):
        self.repo = repo

    def create_question(self, data: CreateQuestionRequest) -> CreatedResponse:
        return self.repo.create_question(data)

    def get_question(self, question_id: UUID) -> DataResponse[dict] | None:
        return self.repo.get_question(question_id)

    def delete_question(self, question_id: UUID) -> DeletedResponse:
        return self.repo.delete_question(question_id)

    def update_question(self, question_id: UUID) -> UpdatedResponse | None:
        return self.repo.update_question(question_id)

    def reorder_question(self, question_id: UUID, new_code: int) -> UpdatedResponse | None:
        return self.repo.reorder_question(question_id, new_code)


def get_question_service(
    repo: QuestionRepository = Depends(get_question_repo),
) -> QuestionService:
    return QuestionService(repo=repo)
