# ADR 0008 — Web-first PWA; native apps later with the entire donate flow in the system browser

**Status**: Accepted · **Date**: 2026-10-04 · corrected 2026-10-05 after the document review (decision unchanged)

## Context
Apple App Review Guidelines 3.2.1(vi)/(vii) and 3.2.2(iv): only approved
nonprofits may collect donations in-app (Apple Pay mandatory, every listed
nonprofit approved via Benevity); individual gifts qualify only if 100% reaches
the receiver; otherwise the app must be free and collect funds in Safari —
Apple rejected even a native amount/email screen shown before opening Safari.
Google Play's billing system must not be used for "peer-to-peer payments,
online auctions, and tax exempt donations", and fee-bearing donations to
non-tax-exempt beneficiaries are not addressed (grey area); new personal developer
accounts need 12 testers × 14 days per app. TypeScript/React is needed for
the web regardless.

## Decision
Mobile-first React PWA through launch. Android via Capacitor 8 (or a Trusted
Web Activity) after launch under the company's Play organisation account with
the "Crowdfunding" financial-features declaration; iOS via Capacitor with the
**whole** `/donate/:jarId` flow opened in `SFSafariViewController` (no amount,
email or payment UI inside the webview), after a legal review. Expo is the
alternative only if native UI becomes essential.

## Consequences
- Web checkout is the compliance path forever; nothing in the payment flow
  may depend on being inside an app.
- Apple Developer Program (US$99/year) deferred until Android/PWA has real
  users; Google Play (US$25) registered early under the company.
