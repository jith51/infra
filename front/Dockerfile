# BUILD
FROM node:22.2.0-slim as base
RUN mkdir /front
WORKDIR /front
COPY ./package.json ./
COPY ./yarn.lock ./
RUN yarn install
COPY . ./

FROM base as dev
WORKDIR /front
ENV NODE_ENV=development
CMD ["yarn", "nuxi", "dev"]

FROM base as prod
WORKDIR /front
ENV NODE_ENV=production
RUN yarn nuxi build
CMD [ "node", ".output/server/index.mjs" ]

