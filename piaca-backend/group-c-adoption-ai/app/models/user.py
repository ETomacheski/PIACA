from datetime import date
from uuid import UUID

from sqlalchemy import Date, Integer, String, Text, text
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID as PostgresUUID

from app.dependencies.database import DataModel


class User(DataModel):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()"),
    )
    email: Mapped[str] = mapped_column(String(255))
    password_hash: Mapped[str] = mapped_column(Text)
    status: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[date | None] = mapped_column("createdat", Date)
    updated_at: Mapped[date | None] = mapped_column("updatedat", Date)
