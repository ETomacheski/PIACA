from datetime import date
from uuid import UUID

from sqlalchemy import Date, Integer, String, Text, text
from sqlalchemy.dialects.postgresql import UUID as PostgresUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.dependencies.database import DataModel


class Question(DataModel):
    __tablename__ = "questions"

    id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()"),
    )
    code: Mapped[int | None] = mapped_column(Integer)
    text: Mapped[str] = mapped_column(Text, nullable=False)
    possible_answers: Mapped[str | None] = mapped_column(Text)
    type: Mapped[str] = mapped_column(String(50), nullable=False)
    created_at: Mapped[date | None] = mapped_column(Date)
    updated_at: Mapped[date | None] = mapped_column(Date)
