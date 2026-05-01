from fastapi import APIRouter

from app.api.routers import adoption, health, survey

api_router = APIRouter()

api_router.include_router(health.router, prefix="/health", tags=["health"])
api_router.include_router(adoption.router, prefix="/adoption", tags=["adoption"])
api_router.include_router(survey.router, prefix="/survey")
