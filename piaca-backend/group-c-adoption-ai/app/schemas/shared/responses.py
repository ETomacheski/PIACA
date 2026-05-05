from datetime import datetime
from typing import Any, Generic, TypeVar
from uuid import UUID

from pydantic import BaseModel

T = TypeVar("T")


class CreatedResponse(BaseModel):
    id: UUID
    created_at: datetime
    function_response: Any | None = None


class UpdatedResponse(BaseModel):
    id: UUID
    updated_at: datetime
    function_response: Any | None = None


class DeletedResponse(BaseModel):
    id: UUID
    deleted: bool


class DataResponse(BaseModel, Generic[T]):
    data: T
