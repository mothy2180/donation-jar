# ADR 0010 — Individual cases are paid to a registered payee (sponsor or hospital/vendor), never to a personal account

**Status**: Accepted · **Date**: 2026-10-05 · Refines the 2026-10-04 decision "organisations first, individuals behind a flag" · corrected the same day after the document review (payee kinds tightened, CLBG approval added)

## Context
The original idea lets donors give to "an individual or an organisation". Research on 2026-10-05 found:
- Curlec's KYC page (2026 Master KYC guidelines): every supported merchant type needs SSM or ROS documents, and "We currently do not support Individual/Unregistered businesses". Route Linked Accounts are created by Curlec Support; no Malaysian KYC list, limits or SLA is published, and the API's `individual` / `not_yet_registered` business types sit beside India-only fields (PAN, GST, IFSC), so they prove nothing for Malaysia.
- Penal Code ss.424A–424D (Act A1721, gazetted 25 Sep 2024) criminalise possessing, lending or transacting through another person's payment instrument without lawful purpose (up to 10 years). PayNet's National Fraud Portal (live Aug 2024) lets banks trace and freeze funds quickly (reported: within 30 minutes) and runs a national mule-account database; a personal account receiving many small third-party credits matches the mule signature.
- Documented donation-sector freezes so far are MACC/AMLA investigations (Aman Palestin 2023, JomDonate 2024, an NGO case in 2026), all about opacity of fund use.
- Apple blocks in-app collection for non-approved fundraisers regardless (ADR 0008).
Several of these rest on headlines because the research search budget ran out; primary texts must be confirmed.

## Decision
- The person in need can be the **beneficiary** of a jar, but the **payee** (the Curlec Linked Account) is always a registered entity: a sponsoring society whose registered objects permit helping unrelated individuals
  (unconfirmed — confirm with ROS/legal), a company limited by guarantee holding
  SSM's prior approval to collect donations from the public (CLBG Guidelines
  para 23(d)), or a Sdn Bhd, that signs the sponsor variant of the Beneficiary
  Agreement for that case, or the hospital/vendor that will be paid (preferred for medical jars).
- `jars.payee_beneficiary_id` records the payee; a trigger refuses any payee whose kind is not company | clbg | society | ngo |
  trust or whose registration number is unverified — so `individual` and
  `not_yet_registered` are refused, and `sole_prop` is allowed only as a
  hospital/vendor payee after legal advice — while
  `platform_settings.direct_individual_payouts = false` (the default). Turning it on requires Curlec's written confirmation **and** legal advice.
- Controls for individual-case jars: KYC-vendor identity + liveness of the patient or guardian (verdict only), medical certificate or other cause evidence, subject consent when the money is for someone else, per-jar cap RM50,000, duration ≤90 days, one active individual-case jar per MyKad (a denormalised
  `jars.subject_ic_hmac` with a partial unique index), payee name equal to the registered payee's legal name.
- The fee policy follows the beneficiary's kind (Model A for individual cases, ADR 0006).
- Staff never hold, view or operate a beneficiary's bank login, card, OTP device or Curlec dashboard.

## Consequences
- Individual cases need a partner: a sponsoring organisation or a cooperative hospital. Finding them is on the non-code track for M5–M7 (PROJECT.md §13).
- The ledger and Route model are unchanged: money still goes from Curlec straight to the payee's own account.
- Questions added to the Curlec day-1 email: hospital and sponsor Linked Accounts (Q3), whether the individual exclusion also applies to Linked Accounts, and whether a society or company may receive funds raised for a named individual it sponsors.
