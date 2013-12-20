# HttpClientDetector gem

A Rack middleware that detects the caracteristics of http client, taking into account platform, browser version. In addition it recognizes bots.

## Quick Installation and Testing
```bash
  git clone https://github.com/experteer/http_client_detector.git
  bundle
  rspec
```

### Setup in your app

add to Gemfile:
```ruby
  gem 'http_client_detector', :git => 'https://github.com/experteer/http_client_detector.git'

  # config/environment.rb (Rails 3):
  config.middleware.use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

  # for other Rack apps
  use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

  # In application_controller.rb access the data using these methods:
  request.env['rack.http_client_info'].phone?
  request.env['rack.http_client_info'].robot?
  request.env['rack.http_client_info'].verified?
```

### Caching the client characteristics in cookies:

It's recommended to cache the obtained data in cookies, use key: 'http_client_info'

```ruby
  before_filter :cache_client_info_in_cookies

  def cache_client_info_in_cookies
    info = request.env['rack.http_client_info']
    if info.verified?
      cookies['http_client_info'] = info.to_json
    end
  end
```
