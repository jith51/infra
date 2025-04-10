# BUILD
FROM node:22.2.0-slim AS base
RUN mkdir /front
WORKDIR /front
COPY ./package.json ./
COPY ./yarn.lock ./
RUN yarn install
COPY . ./

FROM base AS dev
WORKDIR /front
ENV NODE_ENV=development
CMD ["yarn", "nuxi", "dev"]

FROM base AS build
RUN yarn nuxi build

FROM node:22.2.0-slim AS prod
WORKDIR /front

COPY --from=build /front/.output ./.output
COPY --from=build /front/node_modules ./node_modules
COPY --from=build /front/package.json ./package.json

ENV NODE_ENV=production

EXPOSE 3000
CMD [ "node", ".output/server/index.mjs", "--host", "0.0.0.0" ]
