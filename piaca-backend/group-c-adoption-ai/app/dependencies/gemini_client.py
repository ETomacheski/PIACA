from fastapi import HTTPException
from google import genai

from app.core.config import settings


class GeminiClient:
    def __init__(self) -> None:
        self._client = genai.Client(api_key=settings.GEMINI_API_KEY)
        self._model = "gemini-2.0-flash"

    async def complete(self, prompt: str) -> str:
        response = await self._client.aio.models.generate_content(
            model=self._model,
            contents=prompt,
        )
        if not response.text:
            raise HTTPException(
                status_code=424,
                detail="Completion text was returned as None"
            )
        return response.text


gemini_client = GeminiClient()
