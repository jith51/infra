FROM ruby:3.3.1-slim AS api

RUN mkdir /api

WORKDIR /api

RUN apt-get update && apt-get install -y \
  build-essential \
  gcc \
  g++ \
  make \
  pkg-config \
  libpq-dev \
  git \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

RUN mkdir -p /api/log

RUN gem install bundler
RUN bundle config set force_ruby_platform true
# RUN bundle config set --global source https://rubygems.org
RUN bundle install

COPY . /api

RUN gem install foreman

FROM api AS dev
RUN touch /api/log/development.log

FROM api AS prod
RUN touch /api/log/production.log