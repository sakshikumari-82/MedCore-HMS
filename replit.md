# MedCore HMS

Connected Care. Smarter Hospitals. A multi-tenant hospital management platform for clinical operations, patients, appointments, records, prescriptions, labs, billing, and patient portals.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the REST API through the `/api` preview path
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (development only)
- `pnpm --filter @workspace/scripts run seed` — seed demo hospital data
- Required env: `DATABASE_URL`, `SESSION_SECRET`

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- Web: React 19, Vite, Tailwind CSS, React Query, Wouter
- API: Express 5 REST service mounted at `/api`
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod, generated from OpenAPI
- API codegen: Orval
- Build: Vite and esbuild

## Where things live

- `artifacts/medcore-hms` — React/Vite healthcare workspace
- `artifacts/api-server` — REST API, session security, RBAC and tenant checks
- `lib/api-spec/openapi.yaml` — API contract source of truth
- `lib/db/src/schema/index.ts` — normalized PostgreSQL schema source of truth
- `scripts/src/seed.ts` — realistic development seed
- `docs/` — architecture, API, and security notes

## Architecture decisions

- Browser auth uses a signed, short-lived httpOnly session cookie; the frontend never stores credentials or tokens in local storage.
- Every hospital-owned query scopes by the authenticated hospital id; medical records have no delete route.
- The OpenAPI contract generates both client hooks and server validation shapes.
- Storage, Redis queues, realtime events, and monitoring are kept behind configuration seams for later phases.

## Product

Hospital staff can sign in, view live dashboard aggregates, manage patients and appointments, review clinical records, prescriptions, lab orders, billing, audit activity, notifications, branding, and the patient portal foundation.

## User preferences

Keep the MedCore identity and connected-care language consistent. Do not commit `.env` files or secrets.

## Gotchas

Run API codegen after changing `lib/api-spec/openapi.yaml`. Seed after applying the database schema. Use the managed artifact workflows for preview instead of starting root-level dev commands.

## Pointers

- See `README.md` for setup, Docker, CI, deployment preparation, and current limitations.
- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details.