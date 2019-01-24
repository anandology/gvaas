FROM ruby:2.6-alpine
RUN apk add graphviz
ADD . /app
WORKDIR /app
RUN bundle install
ENV APP_ENV production
EXPOSE 4567/tcp
CMD ["bundle", "exec", "ruby", "web.rb"]
