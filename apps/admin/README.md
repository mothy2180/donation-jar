# apps/admin — reviewer/admin console (separate origin)

Empty until Milestone 3. Deliberately a **separate** Vite app served from its own
origin (`admin.<domain>`) behind Cloudflare Access + Supabase TOTP, with a minimal
dependency set and a stricter CSP: review queues, KYC verdict viewer, Linked
Account confirmation, refunds/adjustments. Never shares an origin with
user-generated content or checkout JavaScript (red-team finding, PROJECT.md §10).
