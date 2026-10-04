# ADR 0009 — Python only for offline tooling, never in the request path

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (server-side pHash moved from a Python job to Deno in `receipt-extract`; PROJECT.md §3)

## Context
The founder's strength is Python (computer vision). Free Python hosting that
answers Curlec within 5 seconds does not exist without a credit card or a
server to patch (Cloudflare Python Workers: ~1 s cold start and 10 ms CPU on
Free; Cloud Run needs billing; Render Free sleeps). The fintech-security judge
nevertheless ranked a FastAPI variant first by a hair.

## Decision
Python lives in `scripts/py` (uv) and GitHub Actions: UN/MOHA sanctions-list
parsing, receipt-OCR experiments (PaddleOCR/RapidOCR) and reconciliation reports.
Server-side perceptual hashing of receipts runs in Deno inside `receipt-extract`
(PROJECT.md §7), so duplicate checks finish before review. The request path is TypeScript (Edge
Functions) + SQL. Re-evaluate after the first webhook is on staging (end of
M2); the FastAPI-on-Fly design is the documented escape hatch.
