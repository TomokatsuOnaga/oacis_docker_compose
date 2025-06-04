FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

COPY ./Gemfile /oacis/Gemfile

WORKDIR /oacis

RUN bundle install

COPY ./config/mongoid.yml /oacis/config/mongoid.yml

COPY ./config/cable.yml /oacis/config/cable.yml

COPY ./config/initializers/sidekiq.rb /oacis/config/initializers/sidekiq.rb

COPY ./config/sidekiq.yml /oacis/config/sidekiq.yml

COPY ./config/routes.rb /oacis/config/routes.rb

COPY ./app/workers/job_submitter.rb /oacis/app/workers/job_submitter.rb

COPY ./app/workers/job_observer.rb /oacis/app/workers/job_observer.rb

COPY ./app/workers/parameter_sets_creator.rb /oacis/app/workers/parameter_sets_creator.rb

COPY ./app/controllers/runs_controller.rb /oacis/app/controllers/runs_controller.rb

COPY ./.ssh/config /root/.ssh/config

COPY ./.ssh/id_ed25519 /root/.ssh/id_ed25519

RUN eval "$(ssh-agent -s)" && \
    ssh-add /root/.ssh/id_ed25519 && \
    chmod 600 /root/.ssh/config && \
    chmod 600 /root/.ssh/id_ed25519 && \
    chmod 700 /root/.ssh

RUN mkdir -p /oacis/log

RUN mkdir -p /oacis/tmp/pids

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]