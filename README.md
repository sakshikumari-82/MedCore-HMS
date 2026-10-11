# MedCore HMS

**Connected Care. Smarter Hospitals.**

MedCore HMS is a multi-tenant hospital operations platform foundation for hospital teams and patient-facing workflows. It connects patient registration, appointments, clinical records, prescriptions, labs, billing, notifications, audit activity, and hospital branding through a shared REST API and PostgreSQL data model.

## Implemented

- Tenant-aware hospital, user, patient, appointment, EMR, prescription, lab, invoice, notification, and audit entities.
- Signed httpOnly sessions with salted scrypt password hashing, logout, current-profile flow, and role-aware API authorization.
- Real dashboard aggregates, recent audit activity, patient search, CRUD for patients and appointments, append-only medical records, prescriptions, lab orders, invoices, and hospital branding.
- Responsive MedCore workspace UI with loading, empty, error, confirmation-ready form states, patient portal foundation, and responsive navigation.
- OpenAPI contract, generated Zod validation/client hooks, Drizzle schema, database seed, Docker Compose, Nginx, and GitHub Actions.

## Stack

pnpm monorepo, React 19, Vite, TypeScript, Tailwind CSS, shadcn/ui primitives, Framer Motion-ready UI, React Query, Wouter, Express REST API, Drizzle ORM, PostgreSQL 16, Redis 7-ready configuration, Docker, Nginx, and GitHub Actions.

## Structure

```text
artifacts/medcore-hms/    React application
artifacts/api-server/     REST API and auth/session middleware
lib/api-spec/             OpenAPI source
lib/api-client-react/     Generated React Query hooks
lib/api-zod/              Generated Zod request/response schemas
lib/db/                   PostgreSQL schema and Drizzle client
scripts/src/seed.ts       Realistic demo data
docs/                     Architecture, security, and API notes
Dockerfile, render.yaml, docker-compose.yml   deployment
```

## Quick start (local, no Docker)

```bash
cp .env.example .env            # set SESSION_SECRET (openssl rand -base64 48) and DATABASE_URL
pnpm install
pnpm db:push                    # create / sync tables
SEED_DEMO=true pnpm db:seed     # subscription plans + demo hospital (dev only)
PORT=3001 pnpm --filter @workspace/api-server run dev     # API on :3001
pnpm --filter @workspace/medcore-hms run dev              # web on :5173 (proxies /api to :3001)
```

Demo logins (only when seeded with `SEED_DEMO=true`; password is `DEMO_PASSWORD`, default `MedcoreDemo123!` outside production):
`admin@`, `doctor@`, `nurse@`, `reception@`, `lab@`, `pharmacy@`, `accounts@`, `patient@`, `superadmin@` + `medcore.demo`.

## One-URL production run (Docker)

```bash
cp .env.example .env     # set SESSION_SECRET, SUPER_ADMIN_EMAIL, SUPER_ADMIN_PASSWORD
docker compose up --build
# open http://localhost:8080  ->  "Start your free trial" creates a hospital workspace
```

The single image runs the API **and** serves the built web app on one port, so cookies, CORS and HTTPS are trivial.
See `docs/DEPLOYMENT.md` for Render / VPS steps and Razorpay setup.

## Verify

```bash
pnpm test                                   # unit tests (security, rate limiting, paywall, storage)
pnpm run typecheck                          # needs dependencies installed
pnpm --filter @workspace/api-server run build
pnpm --filter @workspace/medcore-hms run build
```

## How the product earns

1. A hospital signs up at `/register` and gets a free trial (14 days) of the cheapest plan.
2. When the trial ends, creating/changing records is paused (reading still works) until the hospital pays.
3. The hospital admin pays from **SaaS subscription** (Razorpay UPI QR). The webhook verifies the signature and activates the plan.
4. The platform owner (`SUPER_ADMIN_EMAIL`) sees MRR/revenue under **Platform revenue**.

Hospital patient invoices and platform subscription revenue are kept in separate ledgers.

## Known limitations

Not implemented yet: email/SMS delivery and password reset, feature limits per plan tier (plans differ by price/name only),
Redis/BullMQ jobs, realtime sockets, multi-site administration, GST-formatted tax invoices, automated backups.
Local-disk attachments need a persistent volume. The committed `lib/db/drizzle` SQL is stale; use `pnpm db:push` (the supported path).
Health data is regulated (e.g. India's DPDP Act): get a legal/security review before storing real patient records.
