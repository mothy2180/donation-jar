# Balang (working name) — a donation jar you can see through

A Malaysian donation platform where a gift counts **only after the payment
provider confirms it**, the jar's total updates live, and **jar owners must
itemise what they spend on a public ledger with evidence — unexplained balances
are flagged in red**. Fundraisers are vetted before they can collect. Razorpay
Curlec splits each donation at the moment of payment and sends the jar's share to
the verified payee's own account (the organisation itself, or for an individual
case its sponsoring organisation or hospital). We keep only published fees and
optional tips, and never pool donations.

**Everything about this project — problem, decisions and why, architecture,
legal checklist, roadmap, costs, journal — lives in [`PROJECT.md`](PROJECT.md).**
Architecture decisions are in [`docs/adr/`](docs/adr/); runbooks in
[`docs/runbooks/`](docs/runbooks/).

## Licence and repository

AGPL-3.0-only — see [`LICENSE`](LICENSE). Repository: https://github.com/mothy2180/donation-jar
(the product's working name is "Balang"; the repo name stays brand-neutral until the name is final).

## Status

Scaffold only (2026-10-05). No feature code yet. Milestone 0 starts with
[`docs/runbooks/curlec-day1-email.md`](docs/runbooks/curlec-day1-email.md) and
[`docs/runbooks/learning-path.md`](docs/runbooks/learning-path.md); the GitHub
account steps in [`docs/runbooks/github-account.md`](docs/runbooks/github-account.md)
apply to every fresh clone.

## Stack (decided)

React 19 + Vite PWA on Cloudflare Workers static assets · Supabase
(Postgres + RLS, Auth with TOTP, Realtime, Storage, Edge Functions in
TypeScript/Deno) in Singapore · Razorpay Curlec Basic + Route for payments ·
GitHub Actions · Python only for offline tooling.

## Local development (from Milestone 0)

Run everything from the repository root.

**Tools** (every machine):

```bash
brew install supabase/tap/supabase pnpm deno cloudflared age uv pre-commit gitleaks   # Docker Desktop is already installed
```

**One-time project creation** (Milestone 0 week 1; delete this block once its
results are committed, because re-running it on a clone overwrites committed files):

```bash
npm pkg set packageManager="pnpm@$(pnpm --version)"  # pins pnpm for CI
pnpm create vite apps/web --template react-ts        # choose "Ignore files and continue"; keep the package name "web"
git checkout -- apps/web/README.md                   # restore the rules file if the template overwrote it
supabase init                                        # then edit supabase/config.toml (see supabase/README.md)
```

**Every clone**:

```bash
pre-commit install                                   # gitleaks + copy-lint on every commit
pnpm install                                         # commit pnpm-lock.yaml the first time it appears
supabase start                                       # note the "Publishable key"; `supabase status` shows it again
cp supabase/.env.example supabase/.env.local         # EMAIL_ENC_KEY: openssl rand -base64 32 · CRON_SECRET: openssl rand -hex 32
cp apps/web/.env.example apps/web/.env.local         # set VITE_SUPABASE_PUBLISHABLE_KEY to the Publishable key
supabase db reset                                    # migrations + seed, once they exist
```

Daily loop — one terminal each, because they keep running:

```bash
supabase functions serve --env-file supabase/.env.local
pnpm --filter web dev                                # http://localhost:5173
supabase test db                                     # once supabase/tests/*.sql exists
```

`supabase start` **is** the Docker stack (Postgres 54322, API 54321, Studio 54323,
Mailpit 54324); there is no separate `docker-compose.yml`. OrbStack is an optional
alternative to Docker Desktop — don't run both. Nothing here needs a paid plan
until the first real donation, except a domain for custom SMTP; whether Supabase
and Backblaze sign-up need a card is unverified.

## Repository rules

- Public repo under **github.com/mothy2180**. Secrets are never committed:
  gitleaks runs in pre-commit and in CI over the full history; real values live in
  `.env.local` files, never in `.env.example`.
- User-facing copy must pass `scripts/copy-lint.sh`; exemptions only through
  reviewed entries in `scripts/copy-lint-allow.txt`.
- Money is BIGINT sen; the ledger is append-only; donations are recorded only
  from a server-side re-fetch of the payment provider's record.
