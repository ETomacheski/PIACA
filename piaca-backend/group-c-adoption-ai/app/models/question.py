from datetime import date
from uuid import UUID

from sqlalchemy import Date, ForeignKey, Integer, Text, text
from sqlalchemy.dialects.postgresql import UUID as PostgresUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.dependencies.database import DataModel


class QuestionnaireResponse(DataModel):
    __tablename__ = "questionnaire_responses"

    id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()"),
    )
    family_size: Mapped[int | None] = mapped_column(Integer)
    routine: Mapped[str | None] = mapped_column(Text)
    user_id: Mapped[UUID | None] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("users.id"),
        unique=True,
    )
    created_at: Mapped[date | None] = mapped_column("createdat", Date)
    updated_at: Mapped[date | None] = mapped_column("updatedat", Date)
