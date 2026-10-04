# ADR 0004 — Double-entry append-only ledger in Postgres; postings only from re-fetched PSP truth

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (decision unchanged)

## Context
A donation must count only when the payment provider has confirmed it; the
public balance must be auditable forever; webhooks arrive at-least-once and
unordered (Curlec docs); one Curlec order can carry several payment attempts
(a failed FPX then a successful retry); Curlec's payment status list includes
`refunded` (whether a fully refunded payment shows `refunded` or `captured` with
`refund_status = full` is unconfirmed — test in sandbox); refunds are paid from the
platform balance and the gateway fee is not returned.

## Decision
- `ledger.accounts / entries / lines`: double-entry, BIGINT sen, deferred
  constraint trigger (Σdebit = Σcredit at commit), `REVOKE UPDATE/DELETE` plus
  RAISE triggers; corrections only as reversing or maker-checker adjustment
  entries. Entries keyed by `(donation_id, psp_payment_id, kind)`; transfer
  entries by `psp_transfer_id`.
- `psp.events` is an append-only inbox (PII redacted at ingest, unique on the
  provider event id); `psp.event_state` is the mutable companion; `psp.payments`
  has one row per payment attempt; `psp.objects` snapshots the provider's records.
- **Truth-from-PSP**: a webhook only triggers a server-side fetch of the payment,
  its transfers and refunds; the posting plan is computed in TypeScript as a pure,
  unit-tested function and applied atomically by `ledger.apply_plan` (locks the
  donation, skips entry kinds that already exist), called over the direct
  database connection — never through PostgREST. Webhooks, the pending poller
  (per-donation backoff 2/10/30/120 min, then hourly to 24 h), nightly
  reconciliation and admin replay all go through the same path, so ordering never
  matters and a leaked webhook secret cannot credit money.
- Capture posts when `payment.captured = true` (never on `status`). Donation
  states `failed/expired` are re-enterable. Public figures are "confirmed by
  payment provider", with *Transferred* (status `routed`) and *Settled* badges,
  never "in the bank".
- Accounts: `PSP_CLEARING`, `PLATFORM_FLOAT`, `PLATFORM_FEES`, `PLATFORM_TIPS`,
  `PLATFORM_PROCESSING_RECOVERY`, `PROCESSOR_FEES`, `ROUTE_FEES`,
  `PLATFORM_REFUND_LOSS`, `ROUNDING`, `DONOR_FUNDS_HELD`, per Linked Account
  `LINKED_FUNDS` + `BENEFICIARY_BANK`, per jar `JAR_ACCOUNTABLE` + `JAR_SPENT`.

## Consequences
- Most money logic is testable in milliseconds with `deno test` against fixtures;
  Postgres still enforces balance, uniqueness and idempotency.
- Public reads come from projection tables written in the same transaction,
  never from `security_invoker` views over private tables.
- Deno tests of the posting plan must cover: duplicate event,
  transfer-before-capture, failed-then-paid order, first-fact-is-refunded (both
  status shapes), full/partial refunds, refund after settlement.
- pgTAP must cover: `apply_plan` idempotency and skip-existing, the balance
  trigger, append-only denials, the refund guard, RLS denials and that anon cannot
  execute `apply_plan`.
