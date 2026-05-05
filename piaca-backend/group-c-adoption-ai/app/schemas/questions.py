from datetime import date
from enum import Enum

from pydantic import BaseModel, Field, model_validator


class QuestionTypes(Enum):
    TEXT = "text"
    BOOLEAN = "boolean"
    SELECT = "select"
    CHECKBOX = "checkbox"


class SelectableOption(BaseModel):
    option: str


class Question(BaseModel):
    type: QuestionTypes = Field(default=QuestionTypes.TEXT)
    question: str
    possible_answers: list[SelectableOption] = Field(default=[])

    @model_validator(mode="after")
    def validate_possible_answers(self) -> "Question":
        if self.type in (QuestionTypes.SELECT, QuestionTypes.CHECKBOX):
            if len(self.possible_answers) < 2:
                raise ValueError(
                    "possible_answers must have at least 2 options for select and checkbox types"
                )
        return self


class CreateQuestionRequest(Question):
    created_at: date = Field(default_factory=date.today)
    updated_at: date = Field(default_factory=date.today)
