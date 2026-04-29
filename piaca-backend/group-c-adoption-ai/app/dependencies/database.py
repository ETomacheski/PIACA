from typing import Generator
from urllib.parse import quote

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import settings


class DataModel(DeclarativeBase):
    pass


class Database:
    def __init__(self, db_name: str) -> None:
        user = quote(settings.DB_USER, safe="")
        password = quote(settings.DB_PASSWORD, safe="")
        url = (
            f"postgresql+psycopg://{user}:{password}"
            f"@{settings.DB_HOST}:{settings.DB_PORT}/{db_name}"
        )
        self._engine = create_engine(url)
        self._session_factory = sessionmaker(
            bind=self._engine,
            autocommit=False,
            autoflush=False,
        )

    def get_session(self) -> Generator[Session, None, None]:
        session = self._session_factory()
        try:
            yield session
            session.commit()
        except Exception:
            session.rollback()
            raise
        finally:
            session.close()


piaca_db = Database(settings.DB_NAME)