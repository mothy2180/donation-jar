# ADR 0001 — One backend: Supabase (Postgres + RLS + Auth + Realtime + Storage + Edge Functions)

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (decision unchanged)

## Context
A solo, part-time, first-time developer must build and *operate* a system that
records other people's donations. Every additional runtime (a container, a VPS,
a second cloud) is something to patch, monitor and pay for. Facts checked on
2026-10-04: Supabase Free in `ap-southeast-1` is the only free, in-region option
covering database, auth (TOTP), realtime, private storage and serverless
functions, with no commercial-use restriction on its pricing page; Firebase
Spark cannot run this (Functions, Storage and phone auth need Blaze); Vercel
Hobby forbids payment processing; Render Free sleeps (fails Curlec's 5-second
webhook timeout); Fly.io and Railway have no usable free tier; Cloud Run's free
quota needs a billing account.

## Decision
Supabase is the whole backend. Money rules live in Postgres (constraints,
triggers, RLS, pgTAP). Edge Functions (Deno/TypeScript) are a thin shim: verify
the webhook signature → store the raw event → respond 200 → fetch the payment
provider's own records in the background → one database call
(`ledger.apply_plan`) over the direct Postgres connection (`SUPABASE_DB_URL`),
never through PostgREST. The React PWA is served as Cloudflare Workers static
assets. Python is used only offline (scripts, GitHub Actions).

## Consequences
- Free until the first real donation, apart from a domain for custom SMTP
  (whether Supabase and Backblaze sign-up need a card is unverified); then
  Supabase Pro (US$25/month) is mandatory for backups and no pausing.
- Learning curve: TypeScript, React, Deno, PL/pgSQL, RLS, pgTAP (budgeted in M0–M1).
- Single-vendor concentration is mitigated by Curlec's 24-hour webhook retries,
  the pending poller (per-donation backoff 2/10/30/120 min, then hourly to 24 h),
  nightly reconciliation and encrypted off-site dumps.
- Exit path: the ledger is plain Postgres; functions are web-standard fetch
  handlers; `realtime.send` is replaceable by polling.
- Escape hatch (documented, not built): a FastAPI container on Fly.io
  (~US$3–4/month) behind the same SQL ledger, if TypeScript blocks progress after
  the first webhook is on staging (end of M2).
