# BUILD
FROM node:22.2.0-slim as base
WORKDIR /front
COPY package*.json ./
RUN yarn install
COPY . .

FROM base as dev
CMD ["yarn", "nuxi", "dev"]

FROM base as build
RUN yarn nuxi build

FROM build as prod
ENV NODE_ENV=production
CMD [ "node", ".output/server/index.mjs" ]