from sqlalchemy.orm import Mapped, mapped_column
from app.dependencies.database import DataModel

class Adoption(DataModel):
    __tablename__ = "adoptions"

    # need to change to appropriate things
    id: Mapped[int] = mapped_column(primary_key=True)
    pet_name: Mapped[str]
