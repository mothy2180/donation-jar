# ADR 0005 — Identity images live with a KYC vendor and the PSP, not in our database

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (retention changed from one 90-day purge to one per-doc_type schedule; PROJECT.md §3)

## Context
PDPA 2010 as amended (in force by 1 June 2025): face-match outputs are
"biometric data" (sensitive; explicit consent under s.40); a leak of IC numbers
or ID images is a notifiable breach (72 h to the Commissioner, then affected
data subjects within 7 days of that notification); fines up to RM1,000,000; the
Retention Principle (s.10) forbids keeping data longer than necessary. Supabase
has no Malaysia region, so anything stored there is a cross-border transfer
needing a Transfer Impact Assessment or consent. No Malaysian law obliges an
unlicensed platform to keep MyKad copies; only transaction and decision records
need 6–7 years. Curlec collects its own Linked-Account KYC under its merchant
due-diligence duties (Merchant Acquiring Services PD paras 11.1–11.3; whether it
is also an AMLA reporting institution is unconfirmed).

## Decision
- Identity verification of individuals and organisation signatories goes
  through a KYC vendor (Didit: EU hosting, MyKad support, retention set to
  30 days, biometric-template retention off; free tier 500 checks/month until
  31 Oct 2026, then US$10 credit/month ≈ 30 full checks, then ≈US$0.33 per full
  check). We store only the vendor session id, verdict, hashes and reviewer notes.
- Curlec collects Linked-Account (payout) KYC through its own onboarding; we
  forward only what Support asks for, over an encrypted channel, logged.
- Documents we review ourselves live in the private `kyc-docs` bucket in
  `ap-southeast-1`, served via audited 60-second signed URLs from the admin
  origin, on **one retention schedule** (identical in PROJECT.md §8), set as
  `verification_documents.retain_until` per doc_type:
  - bank-statement header, signatory letter, cause evidence (e.g. medical
    certificates): purged 90 days after the decision (30 for rejections);
  - SSM/ROS/ROC certificate, CLBG solicitation approval, constitution: 7 years
    after the relationship ends;
  - s.44(6) letter and religious permission: life of the jars they authorise
    + 7 years;
  - `subject_consent`: while any personal data of the subject is processed or
    published + 7 years (consent metadata also recorded in `audit.log`).
- A 7-year decision record (legal name, peppered IC hash, masked bank account +
  encrypted number, registration numbers, screening results, vendor session id
  and verdict, decision, reviewers, Linked Account id, document hashes) is what
  must survive. The `kyc-docs` bucket is excluded from backups.
- Legal basis: bilingual notice naming every recipient, separate explicit
  consent for sensitive data, a documented Transfer Impact Assessment (3-year
  validity), a DPIA before go-live (facial recognition is a named trigger).
  KYC-related Edge Functions are pinned to `ap-southeast-1` (`x-region`).

## Consequences
- The MVP needs no owner-held encryption keys; browser-side envelope encryption
  stays a Phase-2 option if we ever hold identity images.
- KYC files never go to Cloudflare R2 (no Asia jurisdiction).
- Malaysia-resident fallback, budgeted in case the Commissioner issues restrictive
  guidance: AWS ap-southeast-5 S3 (≈US$0.0225/GB-month) or RDS db.t4g.micro
  (≈US$17/month).
