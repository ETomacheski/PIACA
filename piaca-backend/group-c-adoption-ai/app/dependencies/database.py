from typing import Any, Generator, Mapping, TypeVar
from urllib.parse import quote

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import settings


class DataModel(DeclarativeBase):
    pass


ModelT = TypeVar("ModelT", bound=DataModel)


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

    def add(self, session: Session, model: ModelT) -> ModelT:
        session.add(model)
        session.flush()
        session.refresh(model)
        return model

    def get_by_id(
        self,
        session: Session,
        model_class: type[ModelT],
        model_id: Any,
    ) -> ModelT | None:
        return session.get(model_class, model_id)

    def delete_by_id(
        self,
        session: Session,
        model_class: type[ModelT],
        model_id: Any,
    ) -> bool:
        model = self.get_by_id(session, model_class, model_id)
        if model is None:
            return False

        session.delete(model)
        session.flush()
        return True

    def update_by_id(
        self,
        session: Session,
        model_class: type[ModelT],
        model_id: Any,
        values: Mapping[str, object],
    ) -> ModelT | None:
        """
        Passa um dict em values, e os valores do objeto com id passado
        é o que vai ser alterado.
        """
        model = self.get_by_id(session, model_class, model_id)
        if model is None:
            return None

        for field, value in values.items():
            setattr(model, field, value)

        session.flush()
        session.refresh(model)
        return model


piaca_db = Database(settings.DB_NAME)
