from fastapi import FastAPI

from app.api.main_router import api_router
from app.core.config import settings


def create_app() -> FastAPI:
    app = FastAPI(title=settings.PROJECT_NAME, redirect_slashes=True)
    app.include_router(api_router, prefix=settings.API_PREFIX)

    return app


app = create_app()
