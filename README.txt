== Http Client Detector ==

A Rack middleware that detects the caracteristics of http client,
taking into account platform, browser version.
In addition it recognizes bots.

== Quick Installation ==
Gemfile:
  gem 'http_client_detector', :git => 'https://github.com/experteer/http_client_detector.git'

config/environment.rb (Rails 3):

  config.middleware.use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

For other Rack apps:

  use( HttpClientDetector, :url => 'http://www.tstruk.experteer.de:8080/' )

In your application_controller.rb you can access client info using these accessor methods:

  request.env['rack.http_client_info'].phone?
  request.env['rack.http_client_info'].robot?
  request.env['rack.http_client_info'].verified?


Cahe the client characteristics using Cookies:

  before_filter :cache_client_info_in_cookies

  def cache_client_info_in_cookies
    info = request.env['rack.http_client_info']
    if info.verified?
      cookies['http_client_info'] = info.to_json
    end
  end

