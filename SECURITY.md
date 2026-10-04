# Security policy

Balang records donations that Razorpay Curlec splits directly to verified payees,
and reviews organisations' onboarding documents (identity checks are done by a
KYC vendor; we do not store identity documents). Security reports are welcome and
taken seriously.

## Reporting a vulnerability

- Use GitHub's private vulnerability reporting:
  https://github.com/mothy2180/donation-jar/security/advisories/new
  (an email address will be added once the domain exists).
- Include steps to reproduce, the impact you believe it has, and whether any
  personal data was exposed. Do not include other people's personal data in the
  report.
- We aim to acknowledge within 3 working days and to give a remediation timeline
  within 10 working days.

## Safe harbour

Good-faith research that respects these rules will not lead to legal action: no
data exfiltration beyond what proves the issue, no denial of service, no social
engineering of reviewers or beneficiaries, and no testing against real donations
(use the staging environment once it is public).

## Scope and non-goals

In scope: the web app, the admin app, the Supabase project (RLS, functions,
storage policies), payment webhook handling, ledger integrity.
Out of scope: Razorpay Curlec, Supabase, Cloudflare and other vendors' own
infrastructure (report to them directly).

## Incident handling (internal)

The one-page incident response plan will live in
`docs/runbooks/incident-response.md` (Milestone 5). Malaysian PDPA timelines:
notify the Personal Data Protection Commissioner within 72 hours of a breach
likely to cause significant harm, then affected individuals within 7 days of that
notification.
