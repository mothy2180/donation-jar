# ADR 0003 — No donor wallet (e-money) in the MVP; licensed-partner wallet only as a Phase-3 option

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (decision unchanged)

## Context
Bank Negara Malaysia's Policy Document on Electronic Money (issued and effective
31 January 2025) defines e-money as an instrument that "stores funds
electronically in exchange of funds paid to the issuer" and "is able to be used
as a means of making payment to any person other than the issuer". A reloadable
donor wallet spendable across many jars is exactly that. Issuing it needs BNM
approval under s.11 FSA 2013, a Malaysian company, a Trustee Act trust account,
minimum capital of RM1 million or 8% of outstanding liabilities
(P.U.(A) 403/2022) and BNM-grade governance; unapproved issuance is an offence.
The limited-purpose exemption (P.U.(A) 463/2024, in force 2 Jan 2025) covers only
four categories — single-premise/single-brand purchases within RM1m
liability/volume and RM500 wallet caps, rewards, refunds and telco prepaid — none
of which fits a multi-jar donation wallet.

## Decision
No stored value anywhere in the MVP. Donors pay per donation. No UI element is
called a wallet or dompet: the donor's history page is "Sumbangan saya / My
donations" (read-only), and "e-wallet" appears only as the name of a payment
method. The founder's long-term wish for a donor balance is recorded as
**M8 (Phase 3, research only)**: a white-label arrangement with a BNM-licensed
e-money issuer (BNM's directory flags 13 non-bank EMIs as white-labelling
providers), gated on written legal advice and a signed partner agreement before
any code.

## Consequences
- The original revenue idea (a % on top-ups) disappears with the wallet; see
  ADR 0006 for the replacement.
- copy-lint bans "wallet" and "dompet" as standalone words (e-wallet and e-dompet
  pass), "top-up" and "tambah nilai" in user-facing copy.
- The ledger already models external balances (Linked Accounts), so a future
  partner wallet is an adapter, not a redesign.
