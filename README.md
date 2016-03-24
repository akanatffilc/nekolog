# nekolog
backlog management tool for globaldev

## environment
ruby > 2.2.x
gem install bundler

## install

```
$ bundle install --path vendor/bundle
$ vi config/secrets.yml
```
```development:
  secret_key_base: d27849f287a6aaf4c6cba2f4307404ad299139b3c7cae7cf32249954c05d567768395da1eb53297fe14cb4be837ed8565604f3133a83e49f896fac4217f3b61a
  backlog_client_id: xxx
  backlog_client_secret: xxx
  backlog_space_id: globaldev
```
```
$ bundle exec rake db:migrate
```
