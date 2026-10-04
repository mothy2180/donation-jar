# scripts/

- `copy-lint.sh` — fails when user-facing copy contains banned regulatory wording
  (PROJECT.md §11). Runs in pre-commit and CI. Exemptions: reviewed entries in
  `copy-lint-allow.txt` only.
- Planned (Milestone 1+): `replay-webhook.ts` (signs Curlec fixtures and POSTs them
  locally; `--duplicate`, `--shuffle`, `--refund`), `backup.sh` /
  `restore-test.sh` (`pg_dump | age` → Backblaze B2; the monthly restore drill runs
  on the founder's machine, never on a CI runner).
- No KYC key tooling at MVP — identity documents stay with the KYC vendor (ADR 0005).
- `py/` — offline Python tooling (uv project): sanctions-list parsing (UN XML, MOHA),
  receipt-OCR experiments, reconciliation reports. Never in the request path.
