# HttpClientDetector gem

A Rack middleware that detects the caracteristics of http client, taking into account platform, browser version. In addition it recognizes bots.

## Quick Installation and Testing
```bash
  git clone https://github.com/experteer/http_client_detector.git

  cd http_client_detector
  docker run --rm -it -v $PWD:/detector -p 9292:9292 --name=detector -w /detector  registry.experteer.com/experteer/docker-ruby:2.4.3 /bin/bash
  bundle install --binstubs --path=gems

  bin/rspec spec
```

## Docker Setup
```bash
  git clone https://github.com/experteer/http_client_detector.git
  docker run -it -v $PWD/http_client_detector:/home/default/http_client_detector <ruby-image> bash
  cd http_client_detector/
  bundle
  rspec
```

### Setup in your app

add to Gemfile:
```ruby
  gem 'http_client_detector', :git => 'https://github.com/experteer/http_client_detector.git'

  # config/environment.rb (Rails 3):
  config.middleware.insert_before ActionDispatch::Cookies, HttpClientDetector,
      :url => 'http://www.tstruk.experteer.de:8080/',
      :exclude_hosts => [ /api\.experteer\.com/i, 'www.experteer.at', /\.de$/i ]
  config.middleware.insert_before HttpClientDetector, Rack::Cookies

  # for other Rack apps
  use Rack::Cookies
  use HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/'

  # In application_controller.rb access the data using these methods:
  request.env['rack.http_client_info'].phone?
  request.env['rack.http_client_info'].robot?
  request.env['rack.http_client_info'].verified?
```
