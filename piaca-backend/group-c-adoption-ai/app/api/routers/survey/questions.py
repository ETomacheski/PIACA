from uuid import UUID

from app.services.question import QuestionService, get_question_service
from fastapi import APIRouter, Depends, HTTPException

router = APIRouter(prefix="/questions")


@router.post("/create")
def create_question(
    question_service: QuestionService = Depends(get_question_service),
):
    return question_service.create_question()


@router.delete("/delete/{question_id}")
def delete_question(
    question_id: UUID,
    question_service: QuestionService = Depends(get_question_service),
):
    deleted = question_service.delete_question(question_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Question not found")

    return {"deleted": True}


@router.patch("/update/{question_id}")
def update_question(
    question_id: UUID,
    question_service: QuestionService = Depends(get_question_service),
):
    question = question_service.update_question(question_id)
    if question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    return question


@router.get("/all")
def get_all_questions(
    question_service: QuestionService = Depends(get_question_service),
):
    return


@router.get("/{question_id}")
def get_one_question(
    question_id: UUID,
    question_service: QuestionService = Depends(get_question_service),
):
    question = question_service.get_question(question_id)
    if question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    return question
