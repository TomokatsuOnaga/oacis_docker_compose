FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y build-essential \
    wget libssl-dev libreadline-dev zlib1g-dev
RUN ruby --version
RUN gem install bundler && gem update bundler
RUN rbenv rehash