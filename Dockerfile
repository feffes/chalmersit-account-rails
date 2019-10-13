#Dockerfile for Beta-accounts
FROM ruby:2.3-alpine
MAINTAINER digIT <digit@chalmers.it>
EXPOSE 3000

# Create directories
WORKDIR /usr/src/app

# Install prerequisites
RUN apk add --no-cache \
## Packages
nodejs \
mariadb \
mariadb-client \
curl \
imagemagick \
git \
krb5-dev \
redis \
make \
gcc \
libc-dev

RUN apk add --no-cache sqlite sqlite-dev g++

# Install bundler
RUN gem install bundler
COPY Gemfile Gemfile.lock ./

# Install from Gemfile
RUN bundle install

COPY . .

#RUN bundle exec rake db:create db:migrate 
RUN bundle exec rake rails:update:bin

ENTRYPOINT bundle exec rake db:create db:migrate \
&& rails s -p 3000 -b '0.0.0.0'