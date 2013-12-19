# Http Client Detector gem

A Rack middleware that detects the caracteristics of http client,
taking into account platform, browser version.
In addition it recognizes bots.

## Testing

  git clone https://github.com/experteer/http_client_detector.git
  bundle
  rspec

## Quick Installation

add to Gemfile:
  
  gem 'http_client_detector', :git => 'https://github.com/experteer/http_client_detector.git'

add to config/environment.rb (Rails 3):

  config.middleware.use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

for other Rack apps, add:

  use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

## Using with Rails app

In application_controller.rb access the data using these methods:

  request.env['rack.http_client_info'].phone?
  request.env['rack.http_client_info'].robot?
  request.env['rack.http_client_info'].verified?

### Caching the client characteristics in cookies:

It's recommended to cache the obtained data in cookies, use key: 'http_client_info'

  before_filter :cache_client_info_in_cookies

  def cache_client_info_in_cookies
    info = request.env['rack.http_client_info']
    if info.verified?
      cookies['http_client_info'] = info.to_json
    end
  end

