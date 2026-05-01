from fastapi import Depends
from sqlalchemy.orm import Session

from app.dependencies.database import piaca_db


class SurveyRepository:
    def __init__(
        self,
        session: Session,
    ):
        self.session = session


def get_survey_repo(
    session: Session = Depends(piaca_db.get_session),
) -> SurveyRepository:
    return SurveyRepository(session=session)
