from app.api.routers.survey.questions import router as questions_router
from app.api.routers.survey.survey import router

router.include_router(questions_router)
