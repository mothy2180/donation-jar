# Learning path (≈32 hours, 14 evenings, budgeted inside M0–M1)

Rule: no trigger is written before the trigger learning evening (evening 4).
Each topic comes just before the week that uses it (PROJECT.md §13): evenings
1–11 (≈25 h) fall in M0 and evenings 12–14 (≈7 h) in M1.

| # | When | Topic | Resource | Time |
|---|---|---|---|---|
| 1 | M0 week 1 | RLS: policies, `auth.uid()` / `auth.jwt()`, column grants, Security Advisor, `security_invoker` views | https://supabase.com/docs/guides/database/postgres/row-level-security | 1 evening |
| 2 | M0 week 1 | pgTAP with `supabase test db` | https://supabase.com/docs/guides/database/testing | 1 evening |
| 3–4 | M0 week 2 | PL/pgSQL: functions and exceptions; row triggers (the trigger evening) — Postgres 17 | https://www.postgresql.org/docs/17/plpgsql.html · https://www.postgresql.org/docs/17/sql-createtrigger.html | 2 evenings |
| 5–7 | M0 weeks 2–3 | TypeScript basics, types, generics, async | https://www.typescriptlang.org/docs/handbook/intro.html | 3 evenings |
| 8–9 | M0 weeks 3–4 | React fundamentals: components, props, state, effects | https://react.dev/learn | 2 evenings |
| 10 | M0 week 4 | Supabase quickstart (React) | https://supabase.com/docs/guides/getting-started/quickstarts/reactjs | 1 evening |
| 11 | M0 week 4 | Supabase Auth MFA: TOTP enrol/challenge, `aal2` in RLS | https://supabase.com/docs/guides/auth/auth-mfa | 1 evening |
| 12 | M1 week 1 | PL/pgSQL: deferred constraint triggers (the ledger's balanced-entry check) | https://www.postgresql.org/docs/17/sql-createtrigger.html | 1 evening |
| 13 | M1 | Deno + Edge Functions incl. background tasks (`EdgeRuntime.waitUntil`) | https://supabase.com/docs/guides/functions/background-tasks | 1 evening |
| 14 | M1 | Curlec: Orders, Route, webhooks, test mode | https://curlec.com/docs/payments/route/ | 1 evening |
