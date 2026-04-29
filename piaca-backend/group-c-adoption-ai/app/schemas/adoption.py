from pydantic import BaseModel, Field


class Adoption(BaseModel):
    id: str = Field(alias="_id")
    pet_name: str