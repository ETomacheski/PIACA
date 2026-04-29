from fastapi import Depends

from app.repositories.adoption import AdoptionRepository, get_adoption_repo
from app.schemas.adoption import Adoption

class AdoptionService:
    def __init__(self, repo: AdoptionRepository = Depends(get_adoption_repo)):
        self.repo = repo # will be injected as a dependency

    def list_all(self) -> list[Adoption]:
        # return self.repo.get_all() -- exemplo
        return [
            Adoption(_id="123abc", pet_name="apollo")
        ]
    
    # should have a lot of other methods that will 
    # basically be the main logic for the routes

    # example: the whole logic for actually adopting 
    # (business logic here)

    
def get_adoption_service():
    return AdoptionService()