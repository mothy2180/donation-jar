# ADR 0006 — Revenue: Model C (published beneficiary-side fee for organisations; 0% + optional tip for individual cases; unticked fee cover on all jars)

**Status**: Accepted (founder decision) · **Date**: 2026-10-04 · amended 2026-10-05 by ADR 0010 (individual-case payee) and corrected after the document review (fee-cover wording per model; the cover now pays the transfer fee too; Route transfer fee borne by the beneficiary; PROJECT.md §3)

## Context
The top-up fee died with the wallet (ADR 0003). Abroad, 0% headline fees with
voluntary contributions are the norm (GoFundMe, Milaap, Ketto). Malaysian unit
economics are tighter: gateway fees probably carry 8% service tax (unconfirmed —
Curlec's pricing page says "18% GST", an India template; if charged, FPX is
effectively 1.62%, min RM1.08, and DuitNow Pay 1.30%, min RM0.32), and Route adds
a per-transfer fee (Curlec's docs example: 0.25%; actual rate per plan,
unconfirmed). With processing and transfer fees borne by the beneficiary, a
disclosed 5% deducted fee nets 5% and breaks even near ≈RM13k/month of donations
against ≈RM650/month of fixed company costs, whereas a tips-only model would need
roughly ≈RM43k–130k/month (illustrative tip uptake; ≈RM29k–88k at the year-3 base
of ≈RM440/month). Pre-selected defaults and add-ons are named deceptive design in
the FTC staff report "Bringing Dark Patterns to Light" (Sept 2022); in Malaysia,
CPA 1999 s.10 covers misleading price indications.

## Decision
The fee engine is data (`app.fee_policies` + one SQL `quote_donation()`).
Launch rows:
- **Organisations (launch cohort)** — Model B: a published platform fee deducted
  at the Route split, starting point 3–5% with a per-donation cap and a hard
  `bps ≤ 1000` CHECK; processing and transfer fees itemised separately; every
  public ledger line shows "gift RM50 · fees −RM x".
- **Individual-case jars (when enabled)** — Model A: 0% platform fee; optional
  ringgit tip (opt-in, never pre-selected). The payee is a sponsoring
  organisation or a hospital/vendor (ADR 0010); the fee policy keys on the
  beneficiary's kind.
- **All jars**: an *unticked* processing- and transfer-fee cover (the chosen
  method's processing fee plus Curlec's transfer fee, so a covered Model A gift
  transfers in full) with the all-in total shown before the pay button — "Add
  RM X so [name] receives the full RM Y" only where no platform fee applies
  (Model A); on Model B jars "Add RM X to cover payment-processing and transfer
  fees — [name] receives RM Z after the RM P platform fee".
  Minimum donation RM10, RM20 suggested; gifts under RM20 steered to DuitNow
  Pay/e-wallets once available (FPX's RM1 floor is 10% of RM10). The cover differs by
  payment method, so it is subject to Curlec/PayNet confirming that breaches no
  surcharging rule (day-1 email Q12).
- Uncovered processing and transfer fees are borne by the beneficiary by default,
  so the platform never silently subsidises; the platform's Curlec balance is
  prefunded (~RM500) because Route debits gateway fees from it.

## Consequences
- Platform revenue (platform fees, fee covers, tips) is taxable business income
  and counts toward the SST registration threshold, most plausibly Group G
  (8%, RM500,000; confirm with RMCD or a Customs ruling); pass-through donations
  count toward neither SST nor the LHDN e-Invoice RM3m threshold.
- Review the model with real data after six months; a flat per-jar success fee is
  the fallback if volume stays below ≈RM15k/month.
- The `/fees` page and every acknowledgement carry the full fee schedule
  (Consumer Protection (Electronic Trade Transactions) Regulations 2024
  [P.U.(A) 449/2024]).
