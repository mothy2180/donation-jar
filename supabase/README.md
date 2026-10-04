# supabase/ — database, auth, storage, edge functions

From the **repository root** (never inside this folder) run `supabase init`; it
creates `supabase/config.toml`. Change these keys in the sections it generated
(don't append duplicate `[auth]` headers — TOML rejects them) and apply them with
`supabase stop && supabase start`:

```toml
[api]
schemas = ["app"]   # only `app` is exposed to PostgREST (PROJECT.md §4); never add ledger, psp, audit or ops

[auth]
site_url = "http://localhost:5173"
additional_redirect_urls = ["http://localhost:5173/**"]
minimum_password_length = 15

[auth.mfa.totp]
enroll_enabled = true
verify_enabled = true

[edge_runtime]
policy = "per_worker"   # needed for EdgeRuntime.waitUntil from M2; disables hot reload, so restart
                        # `supabase functions serve` after edits (keep "oneshot" until then)
```

Add `[functions.<name>] verify_jwt = false` for `health`, `psp-webhook-curlec`,
`create-checkout` and `checkout-callback` as each is created. Leave
`[auth.captcha]` commented out until the sign-up form shows the Turnstile widget
(test site key `1x00000000000000000000AA`); then set `enabled = true`,
`provider = "turnstile"`, `secret = "env(TURNSTILE_SECRET)"` and export
`TURNSTILE_SECRET` before `supabase start`.

Because only `app` is exposed, create the browser client with
`createClient(url, publishableKey, { db: { schema: "app" } })`. `config.toml`
configures only the local stack: on each hosted project (staging in M2,
production in M5) set Data API → Exposed schemas to `app` only.

The local stack (`supabase start`) **is** our Docker environment: Postgres 54322,
API 54321, Studio 54323, Mailpit 54324, Realtime, Storage, Edge runtime.

## Migration order (PROJECT.md §5, §13)

Numbered in build order; name each file `migrations/<NNNN>_<name>.sql` (e.g.
`0020_ledger.sql`) rather than using `supabase migration new` timestamps.
Never add a migration numbered below the last one applied to staging —
`supabase db push` rejects it.

- **0001 extensions**: `create extension if not exists pg_cron with schema pg_catalog;`
  `create extension if not exists pg_net with schema extensions;`
  `create extension if not exists pg_trgm with schema extensions;`
  `create extension if not exists pgmq;`
- **0002 schemas** `app`, `ledger`, `psp`, `audit`, `ops`;
  `grant usage on schema app to anon, authenticated;`
  `alter default privileges for role postgres revoke execute on functions from public;`
  (global, because Postgres grants EXECUTE to PUBLIC by default and a per-schema
  revoke cannot undo that; 0001's extensions were created before it and keep
  their defaults). Then grant EXECUTE only where needed: to `anon, authenticated`
  on the public RPCs (`app.quote_donation`, `app.donation_status`) and on helper
  functions used inside RLS policies, and to `authenticated` on signed-in RPCs.
  pgTAP checks `select ok(not has_function_privilege('anon', 'app.<fn>(<args>)', 'execute'));`
  for every other `app` function.
- **Every later migration enables RLS and writes the policies and column grants
  for the tables it creates** — never "add RLS later".
- 0010 profiles, beneficiaries, jars, donations, platform_settings, state_transitions (M0)
- 0020 ledger + jar_balances · 0030 psp inbox + payments · 0040 jar_feed + realtime trigger · 0050 public projection tables (M1)
- 0060 fee_policies · 0070 cron + queues + email_outbox + `ops.alerts`, `ops.rate_limits`, `ops.reconciliation_runs` (M2)
- 0080 onboarding/KYC (incl. religious_permissions, donation_receipt_requests) · 0090 audit + `ops.breach_register` (M3)
- 0100 expenses/evidence + expense_flags, jar_updates, abuse_reports (M4)

## Rules

RLS on every table; only schema `app` is exposed to PostgREST; `ledger.*` and
`psp.*` are called from Edge Functions over the direct database connection
(`SUPABASE_DB_URL`); views are `security_invoker`; `SECURITY DEFINER` functions
pin `search_path = ''`; money is BIGINT sen; the ledger is append-only. Tests are
pgTAP in `tests/` (`supabase test db`); the RLS denial sweep there grows with
each milestone, and the full sweep is the M5 release gate. **Never paste the
`GRANT ALL … TO anon, authenticated` snippet from Supabase's custom-schema
guide.**
