from uuid import UUID

from fastapi import APIRouter, Body, Depends, HTTPException

from app.schemas.questions import CreateQuestionRequest
from app.schemas.shared.responses import CreatedResponse, DataResponse, DeletedResponse, UpdatedResponse
from app.services.question import QuestionService, get_question_service

router = APIRouter(prefix="/questions")


@router.post("/", response_model=CreatedResponse, status_code=201)
def create_question(
    data: CreateQuestionRequest,
    question_service: QuestionService = Depends(get_question_service),
):
    return question_service.create_question(data)


@router.delete("/{question_id}", response_model=DeletedResponse)
def delete_question(
    question_id: UUID,
    question_service: QuestionService = Depends(get_question_service),
):
    return question_service.delete_question(question_id)


@router.patch("/{question_id}/reorder", response_model=UpdatedResponse)
def reorder_question(
    question_id: UUID,
    new_code: int = Body(..., embed=True),
    question_service: QuestionService = Depends(get_question_service),
):
    try:
        result = question_service.reorder_question(question_id, new_code)
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    if result is None:
        raise HTTPException(status_code=404, detail="Question not found")
    return result


@router.patch("/{question_id}", response_model=UpdatedResponse)
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


@router.get("/{question_id}", response_model=DataResponse[dict])
def get_one_question(
    question_id: UUID,
    question_service: QuestionService = Depends(get_question_service),
):
    question = question_service.get_question(question_id)
    if question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    return question
