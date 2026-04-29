from fastapi import APIRouter, Depends
from app.services.adoption import AdoptionService, get_adoption_service
from app.schemas.adoption import Adoption

router = APIRouter()


@router.get("/")
def get_all_adoptions(
    adoption_service: AdoptionService = Depends(get_adoption_service)
) -> list[Adoption]:
    return adoption_service.list_all()
