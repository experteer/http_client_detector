== Http Client Detector ==

A Rack middleware to detect basic caracteristics of http client (browser+device)


== Usage (Rails 3) ==
Add it your Gemfile:
gem 'http_client_detector', :git => 'https://github.com/experteer/http_client_detector.git'

Ad it to your Rack stack:
use HttpClientDetector

In your application_controller.rb you can access client info:

request.env['rack.http_client_info'].phone?
request.env['rack.http_client_info'].robot?

Status check:
request.env['rack.http_client_info'].ok?

