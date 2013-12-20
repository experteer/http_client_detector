require 'http_client_info'
require 'cgi'
require 'json'
require 'logger'
require 'rack/contrib/cookies'

class HttpClientDetector

  def initialize(app, config={ })
    @app=app
    @config = config
    @cookies = nil
  end

  attr_reader :cookies

  def call(env)
    @cookies = env['rack.cookies']

    info = Rack::HttpClientInfo.new.load_from_raw_data( data_from_cookies ) # (env) || data_from_cookies(env['HTTP_COOKIE'])
    unless info.verified?
      info = Rack::HttpClientInfo.new.load_from_raw_data(  data_from_service(env['HTTP_USER_AGENT']) )
    end


    env['rack.http_client_info'] = info

    status, headers, body = @app.call(env)

    # cookies = env['action_dispatch.cookies']
    logger.debug("http_client_detector: COOKIES BEFORE: #{ cookies.inspect }")

    if cookies && cookies['http_client_info'].nil? && info.verified?
      cookies['http_client_info'] = info.to_json
    end

    logger.debug("http_client_detector: COOKIES AFTER: #{ cookies.inspect }")

    [status, headers, body]
  end


  private

  def logger
    @logger ||= ( defined?(Rails) ?
        Rails.logger :
        Logger.new(File.join(File.dirname(__FILE__), '../log/', "#{ENV['RACK_ENV'] || ENV['RAILS_ENV']}.log" ))
    )
  end

  def data_from_cookies
    logger.debug("http_client_detector: RACK COOKIES #{ cookies.inspect }") if cookies
    if cookies && cookies['http_client_info']
      JSON.parse(cookies['http_client_info'])
    end

  rescue => e
    logger.error("http_client_detector: extracting data from cookies failed: #{e.class} #{e.message}")
    nil
  end

  def data_from_service(user_agent)
    resp = RestClient.get(@config[:url], { :accept => :json, :user_agent =>  user_agent})

    logger.debug "http_client_detector: service request finished, status == #{ resp.code }"
    JSON.parse(resp.body)

  rescue => e
    logger.error("http_client_detector: getting data from service failed: #{e.class} #{e.message}")
    nil
  end

end