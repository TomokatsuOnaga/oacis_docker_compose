FROM ruby:2.7.8

RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git

COPY ./Gemfile /oacis/Gemfile

WORKDIR /oacis

RUN bundle install

COPY ./config/*.yml ./config/routes.rb /oacis/config/

COPY ./config/initializers/sidekiq.rb /oacis/config/initializers/sidekiq.rb

COPY ./app/workers/*.rb /oacis/app/workers/

COPY ./app/controllers/runs_controller.rb /oacis/app/controllers/runs_controller.rb

RUN mkdir -p /oacis/log

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]