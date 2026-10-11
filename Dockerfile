# One image = the whole product: Express API + the built React app on a single port.
FROM node:22-slim
RUN corepack enable && corepack prepare pnpm@10.26.1 --activate
WORKDIR /app

# Install first (cache-friendly), then build.
COPY . .
RUN pnpm install --frozen-lockfile

ENV PORT=3000 BASE_PATH=/
RUN pnpm --filter @workspace/medcore-hms run build \
 && pnpm --filter @workspace/api-server run build

ENV NODE_ENV=production \
    TZ=Asia/Kolkata \
    LOCAL_STORAGE_DIR=/app/data/uploads
VOLUME ["/app/data"]
EXPOSE 3000

# On every start: sync the database schema, make sure plans exist (and the platform owner when
# SUPER_ADMIN_EMAIL/PASSWORD are set), then run the server.
CMD ["sh", "-c", "pnpm --filter @workspace/db run push-force && pnpm --filter @workspace/scripts run seed && exec node --enable-source-maps artifacts/api-server/dist/index.mjs"]
