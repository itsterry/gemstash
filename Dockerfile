FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential curl

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .
COPY config.ru /app/config.ru
COPY config.yml /app/config.yml

VOLUME /data

EXPOSE 9292

ENV GEMSTASH_CACHE=/data/cache
ENV GEMSTASH_STORAGE=/data/storage
ENV GEMSTASH_CONFIG=/app/config.yml

CMD ["rackup", "/app/config.ru", "-p", "9292", "-E", "production"]
