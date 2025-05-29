FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

WORKDIR /oacis

RUN bundle install

COPY ./web/mongoid.yml /oacis/config/mongoid.yml

COPY ./web/cable.yml /oacis/config/cable.yml

RUN mkdir -p /oacis/tmp

RUN mkdir -p /oacis/logs

WORKDIR /oacis/lib/tasks

COPY ./job_submitter/boot_job_submitter_worker.rb /oacis/lib/tasks/boot_job_submitter_worker.rb

CMD ["ruby", "./boot_job_submitter_worker.rb"]