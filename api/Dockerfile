FROM ruby:3.2.2 AS api

RUN mkdir /api

WORKDIR /api

COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

RUN mkdir -p /api/log

RUN gem install bundler
RUN bundle install

COPY . /api

RUN gem install foreman

FROM api AS dev
RUN touch /api/log/development.log

FROM api AS prod
RUN touch /api/log/production.log