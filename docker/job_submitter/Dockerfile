FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

COPY ./mongoid.yml /oacis/config/mongoid.yml

COPY ./cable.yml /oacis/config/cable.yml

WORKDIR /oacis

RUN bundle install

RUN mkdir -p /oacis/logs

WORKDIR /oacis/lib/tasks

COPY ./boot_job_submitter_worker.rb /oacis/lib/tasks/boot_job_submitter_worker.rb

CMD ["bundle", "exec", "ruby", "-r", "'/oacis/config/environment.rb'", "./boot_job_submitter_worker.rb", "start"]