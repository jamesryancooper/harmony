from __future__ import annotations

from typing import List, Optional

from pydantic import BaseModel, Field


class CompletionRequest(BaseModel):
    """Request schema for text completions."""

    prompt: str = Field(..., description="User prompt for the LLM")
    model: Optional[str] = Field(default=None, description="LLM model identifier")
    temperature: Optional[float] = Field(default=0.7, ge=0.0, le=2.0)
    max_tokens: Optional[int] = Field(default=256, ge=1)


class CompletionResponse(BaseModel):
    """Response schema for text completions."""

    output: str
    model: str
    promptTokens: int
    completionTokens: int
    totalTokens: int


class EmbeddingRequest(BaseModel):
    """Request schema for embeddings."""

    input: str = Field(..., description="Text to embed")
    model: Optional[str] = Field(default=None, description="Embedding model identifier")


class EmbeddingResponse(BaseModel):
    """Response schema for embeddings."""

    embedding: List[float]
    model: str


