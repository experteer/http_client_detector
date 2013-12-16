== Http Client Detector ==

A Rack middleware to detect basic caracteristics of http client


== Usage (Rails 3) ==
Add it to your Gemfile:
gem "http_client_detector"

Ad it to your Rack stack:
use Rack::HttpClientDetector

In your application_controller.rb you can access client info:

env['http_client_info'].phone?
env['http_client_info'].robot?

and get it's matched robot name with
env['rack_detect_robots'].robot_name
