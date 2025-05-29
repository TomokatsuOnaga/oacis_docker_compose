FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

WORKDIR /oacis

RUN bundle install

EXPOSE 3000

CMD ["bundle", "exec", "rake", "daemon:start"]