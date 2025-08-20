FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential curl

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .

VOLUME /data

EXPOSE 9292

CMD ["gemstash", "start", "--no-daemonize"]
