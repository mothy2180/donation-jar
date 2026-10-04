# apps/web — donor site, jar-owner console (React PWA)

Empty until Milestone 0 (`pnpm create vite apps/web --template react-ts`, see the
root README). Planned: React 19 + TypeScript + Vite PWA, TanStack Router/Query,
Tailwind, react-i18next (`ms` primary, `en`), supabase-js with the publishable key
only. Routes: `/`, `/j/:slug`, `/donate/:jarId`, `/d/:donationId`, `/me`,
`/owner/*`, `/fees`, `/trust`, `/legal/*`.

Rules that apply from the first commit:
- No secret keys in this app. Ever. Only `VITE_SUPABASE_PUBLISHABLE_KEY`.
- Every payment screen shows gift, processing fee and transfer fee (incl. service
  tax once Curlec confirms it), platform fee (if any), optional fee cover
  (unticked; wording depends on the jar's fee model — PROJECT.md §9), optional tip
  (Model A jars only), total charged and "jar receives". Never call the fee cover
  a "top-up".
- User-facing copy lives in `src/locales/{ms,en}.json` (one key per line) and
  `src/content/legal/{ms,en}/*.md`, and must pass `scripts/copy-lint.sh`. Enforce
  `i18next/no-literal-string` in ESLint so components hold no copy.
