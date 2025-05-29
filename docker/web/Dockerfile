FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

WORKDIR /oacis

RUN bundle install

COPY ./mongoid.yml /oacis/config/mongoid.yml

COPY ./cable.yml /oacis/config/cable.yml

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]