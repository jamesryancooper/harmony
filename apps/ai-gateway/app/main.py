from __future__ import annotations

import os
import structlog
from fastapi import FastAPI, HTTPException
from litellm import acompletion, aembedding

from app.schemas import (
    CompletionRequest,
    CompletionResponse,
    EmbeddingRequest,
    EmbeddingResponse,
)
from app.otel import init_otel


logger = structlog.get_logger().bind(svc="ai-gateway")

app = FastAPI(title="AI Gateway", version="0.0.1")
_shutdown_otel = init_otel(app)


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/v1/llm/completions", response_model=CompletionResponse)
async def create_completion(req: CompletionRequest) -> CompletionResponse:
    """
    Minimal model-agnostic completion endpoint using LiteLLM.
    Provider API keys are read from env (e.g., OPENAI_API_KEY, ANTHROPIC_API_KEY).
    """
    model = req.model or os.getenv("LITELLM_MODEL", "gpt-4o-mini")
    try:
        resp = await acompletion(
            model=model,
            messages=[{"role": "user", "content": req.prompt}],
            temperature=req.temperature or 0.7,
            max_tokens=req.max_tokens or 256,
        )
        content = resp.choices[0].message["content"]
        usage = resp.usage or {}
        return CompletionResponse(
            output=content,
            model=resp.model or model,
            promptTokens=int(usage.get("prompt_tokens", 0)),
            completionTokens=int(usage.get("completion_tokens", 0)),
            totalTokens=int(usage.get("total_tokens", 0)),
        )
    except Exception as e:  # noqa: BLE001
        logger.exception("completion_error", err=str(e), model=model)
        raise HTTPException(status_code=502, detail="Upstream LLM error") from e


@app.post("/v1/embeddings", response_model=EmbeddingResponse)
async def create_embedding(req: EmbeddingRequest) -> EmbeddingResponse:
    """Vendor-agnostic embeddings via LiteLLM."""
    model = req.model or os.getenv("LITELLM_EMBED_MODEL", "text-embedding-3-small")
    try:
        resp = await aembedding(model=model, input=req.input)
        vec = resp.data[0]["embedding"]  # type: ignore[index]
        return EmbeddingResponse(embedding=vec, model=model)
    except Exception as e:  # noqa: BLE001
        logger.exception("embedding_error", err=str(e), model=model)
        raise HTTPException(status_code=502, detail="Upstream embeddings error") from e


