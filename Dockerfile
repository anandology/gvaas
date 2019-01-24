FROM ruby:2.6
ENV DEBIAN_FRONTEND notinteractive
RUN apt-get update && apt-get -y install graphviz
ADD . /app
WORKDIR /app
RUN bundle install
ENV APP_ENV production
EXPOSE 4567/tcp
CMD ["bundle", "exec", "ruby", "web.rb"]
