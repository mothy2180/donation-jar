# ADR 0002 — Pass-through payments via Razorpay Curlec Route; donations are split at payment and never pooled

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (decision unchanged; custody wording made accurate, route-failed money booked to `DONOR_FUNDS_HELD`)

## Context
Pooling donations in a platform bank account and paying beneficiaries later
risks "merchant acquiring / payment aggregation" under s.17 FSA 2013 (BNM:
intermediaries are "not automatically required to register, nor exempt") and is
prohibited by several PSPs' terms (Billplz bans "payment aggregators" and
"unregulated charities"). The SC's Social Exchange Platform guidelines
(19 Sep 2025) themselves require *direct* donor-to-NPO payment — a signal that
regulators want pass-through. Curlec (a BNM-registered acquirer) offers Route:
each Order can carry `transfers[]` to a Linked Account, fixed before the donor pays.

## Decision
Every donation is a Curlec Order with the Route transfer to the payee's confirmed
Linked Account attached **at order creation** (`on_hold: false`). The payee is the
organisation itself or, for an individual case, its sponsoring organisation or
the hospital/vendor (ADR 0010). The payee's share leaves the platform's Curlec
balance automatically at capture. Otherwise that balance holds only the
platform's fee share, fee covers, tips and a small self-funded refund float, plus
donor money in transit: a payee's share whose transfer failed, booked to
`DONOR_FUNDS_HELD` from the failure until it is routed or refunded (≤24 h of
retries), and refunds on their way back to donors. Both are tracked per donation
in the ledger and reported on the Trust page; nothing legally ring-fences that
balance, so the documents never claim it is.

**Stop-ship rule**: production refuses to create orders if order-level transfers
are unavailable; there is no fallback to capture-then-transfer (that would be the
banned custody model).

## Consequences
- No wallet, no pooled funds, no e-money (ADR 0003).
- Refunds are paid from the platform's own Curlec balance and the gateway fee is
  not returned (Curlec docs), so a `PLATFORM_FLOAT` (company money) and a
  `PLATFORM_REFUND_LOSS` account exist; the refund policy is deliberately narrow.
- `route_failed` has an SLA: automatic retries to the same Linked Account for
  6 h, then an auto-refund before the platform's next settlement cut-off.
- Beneficiary onboarding is not self-serve (Curlec Support creates Linked
  Accounts) — states `approved_pending_psp → psp_requested → live`.
- Open items for Curlec (`docs/runbooks/curlec-day1-email.md`): Route on Basic,
  Linked-Account KYC, donation activity acceptance, SST on fees, fees on refund,
  fee cover, Linked Accounts API.
- Settlement holds (payout-on-proof) are a Phase-2 question for BNM and legal
  advice, not an engineering toggle (`docs/runbooks/bnmlink-enquiry.md`).
