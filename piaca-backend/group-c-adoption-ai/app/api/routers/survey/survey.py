from app.services.survey import SurveyService, get_survey_service
from fastapi import APIRouter, Depends

router = APIRouter(tags=["survey"])


@router.post("/{user_id}")
def answer_survey(
    user_id: str, survey_service: SurveyService = Depends(get_survey_service)
) -> dict[str, str]:
    return {"user_id": user_id}


@router.get("/{user_id}")
def get_user_answers(
    user_id: str, survey_service: SurveyService = Depends(get_survey_service)
):
    return


@router.put("/{user_id}")
def update_answers(
    user_id: str, survey_service: SurveyService = Depends(get_survey_service)
):
    return
