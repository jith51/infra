FROM node:22-slim AS base

RUN corepack enable

RUN mkdir /front
WORKDIR /front

COPY ./package.json ./
COPY ./pnpm-lock.yaml ./

ENV CI=true
ENV PNPM_CONFIRM_MODULES_PURGE=false

RUN corepack enable 
# && corepack prepare pnpm@latest --activate

# INSTALL DEPS
FROM base AS deps
# COPY package.json pnpm-lock.yaml ./
# RUN pnpm install --frozen-lockfile
# Install production dependencies
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile --dangerously-allow-all-builds

# DEV
FROM base AS dev
ENV NODE_ENV=development
# Install build dependencies
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile --dangerously-allow-all-builds
COPY . ./
# Build the TypeScript
# CMD ["pnpm", "dev"]
CMD ["pnpm", "nuxi", "dev"]
# CMD ["pnpm", "dev"]


# BUILD
FROM base AS build
# Install build dependencies
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
# Build the TypeScript
RUN pnpm run build
# Create an image base


# PROD
FROM node:22-slim AS prod
WORKDIR /front

ENV NODE_ENV=production
ENV HOST=0.0.0.0

COPY --from=build /front/.output ./.output
COPY --from=build /front/node_modules ./node_modules
COPY --from=build /front/package.json ./package.json

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]