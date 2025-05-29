FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

COPY ./Gemfile /oacis/Gemfile

WORKDIR /oacis

RUN bundle install

COPY ./mongoid.yml /oacis/config/mongoid.yml

COPY ./cable.yml /oacis/config/cable.yml

COPY ./sidekiq.rb /oacis/config/initializers/sidekiq.rb

COPY ./sidekiq.yml /oacis/config/sidekiq.yml

COPY ./routes.rb /oacis/config/routes.rb

COPY ./job_submitter.rb /oacis/app/workers/job_submitter.rb

COPY ./job_observer.rb /oacis/app/workers/job_observer.rb

COPY ./document_destroyer.rb /oacis/app/workers/document_destroyer.rb

COPY ./parameter_sets_creator.rb /oacis/app/workers/parameter_sets_creator.rb

RUN mkdir -p /oacis/log

RUN mkdir -p /oacis/tmp/pids

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]