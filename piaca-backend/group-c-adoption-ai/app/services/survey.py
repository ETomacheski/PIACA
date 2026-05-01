from fastapi import Depends

from app.repositories.survey import SurveyRepository, get_survey_repo


class SurveyService:
    def __init__(self, repo: SurveyRepository):
        self.repo = repo


def get_survey_service(
    repo: SurveyRepository = Depends(get_survey_repo),
) -> SurveyService:
    return SurveyService(repo=repo)
