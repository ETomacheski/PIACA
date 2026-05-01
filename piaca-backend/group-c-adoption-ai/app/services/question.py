from uuid import UUID

from fastapi import Depends

from app.repositories.question import QuestionRepository, get_question_repo


class QuestionService:
    def __init__(self, repo: QuestionRepository):
        self.repo = repo

    def create_question(self) -> dict[str, object]:
        return self.repo.create_question()

    def get_question(self, question_id: UUID) -> dict[str, object] | None:
        return self.repo.get_question(question_id)

    def delete_question(self, question_id: UUID) -> bool:
        return self.repo.delete_question(question_id)

    def update_question(self, question_id: UUID) -> dict[str, object] | None:
        return self.repo.update_question(question_id)


def get_question_service(
    repo: QuestionRepository = Depends(get_question_repo),
) -> QuestionService:
    return QuestionService(repo=repo)
