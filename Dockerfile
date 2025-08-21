FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential curl

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .
COPY config.ru /app/config.ru

VOLUME /data

EXPOSE 9292

CMD ["rackup", "/app/config.ru", "-p", "9292", "-E", "production"]
