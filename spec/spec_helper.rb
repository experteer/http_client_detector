$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'http_client_detector'

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'json'
require 'cgi'
require 'webmock/rspec'
require 'pry'

WebMock.disable_net_connect!

module RSpecAppMixin
  include Rack::Test::Methods

  def app()
    (Rack::Builder.new {
      map '/' do
        use Rack::Cookies
        use HttpClientDetector, :url => 'http://client-detector-test.experteer.com/', :exclude_hosts => [/^api/i, 'admin.experteer.de'] # 'http://localhost:4567/'
        run lambda { |env| [200, { 'Content-Type' => 'application/json' }, env['rack.http_client_info'].to_json  ] }
      end
    }).to_app
  end

end

RSpec.configure do |c|
  c.include RSpecAppMixin
  c.add_setting :detector_test_url, :default => 'http://client-detector-test.experteer.com/debug'
end
