FROM ruby:2.7.8

# download oacis
RUN git clone --recursive -b master https://github.com/crest-cassia/oacis.git
WORKDIR /oacis

# install gems
COPY ./Gemfile /oacis/Gemfile
RUN bundle install

# copy files modified for docker compose
COPY ./config/*.yml ./config/routes.rb /oacis/config/
COPY ./config/initializers/sidekiq.rb /oacis/config/initializers/sidekiq.rb
COPY ./app/workers/*.rb /oacis/app/workers/
COPY ./app/controllers/runs_controller.rb /oacis/app/controllers/runs_controller.rb

RUN mkdir -p /oacis/log

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]