FROM ruby:2.5.1-slim
LABEL maintainer="breakathon@pagerduty.com"
RUN apt-get update && apt-get install -qq -y build-essential default-libmysqlclient-dev --fix-missing --no-install-recommends
ENV INSTALL_PATH /home/ubuntu/
ENV APP_ENV production
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile
RUN bundle install
COPY app.rb .
VOLUME ["$INSTALL_PATH/public"]
CMD /usr/local/bin/ruby /home/ubuntu/app.rb 