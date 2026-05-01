from fastapi import Depends
from sqlalchemy.orm import Session

from app.dependencies.database import piaca_db
from app.schemas.adoption import Adoption


class AdoptionRepository:
    def __init__(
        self,
        session: Session,
    ):
        self.session = session

    def read_many_adoptions(self) -> list[Adoption]:
        return [Adoption(_id="123456789", pet_name="mel")]


def get_adoption_repo(
    session: Session = Depends(piaca_db.get_session),
) -> AdoptionRepository:
    return AdoptionRepository(session=session)
