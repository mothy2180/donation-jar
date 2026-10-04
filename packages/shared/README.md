# packages/shared

Types and pure functions shared by the web app, the admin app and the Deno edge
functions: generated `database.types.ts`, `money.ts` (BIGINT-sen helpers),
PSP event schemas (zod), and the **posting-plan** function
`plan(donation, facts, existingEntryKinds) -> entries[]` that is unit-tested
against fixtures and applied atomically by the `ledger.apply_plan` RPC.
