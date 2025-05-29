FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

COPY ./mongoid.yml /oacis/config/mongoid.yml

COPY ./cable.yml /oacis/config/cable.yml

WORKDIR /oacis

RUN bundle install

RUN mkdir -p /oacis/logs

RUN mkdir -p /oacis/tmp/pids

EXPOSE 3000

CMD ["bundle", "exec", "rake", "daemon:start"]