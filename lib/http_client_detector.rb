require "#{File.dirname(__FILE__)}/http_client_info"
require 'cgi'
require 'json'
require 'logger'
require 'rest_client'
require 'rack/contrib/cookies'

class HttpClientDetector

  def initialize(app, config={ })
    @app = app
    @config = config
  end


  def call(env)
    request = Rack::Request.new(env)

    unless allow_detection_for_request?(request)
      return @app.call(env)
    end

    cookies = env['rack.cookies']

    info = Rack::HttpClientInfo.new.load_from_raw_data( data_from_cookies(cookies) )
    unless info.verified?
      info = Rack::HttpClientInfo.new.load_from_raw_data(  data_from_service( request.user_agent ) )
    end


    env['rack.http_client_info'] = info

    status, headers, body = @app.call(env)

    if cookies && cookies['http_client_info'].nil? && info.verified?
      cookies['http_client_info'] = info.to_json
    end


    [status, headers, body]
  end


  private


  def allow_detection_for_request?(request)
    return false unless request.get?

    ex_hosts = @config[:exclude_hosts] || @config[:exclude_host] || [ ]
    hosts_to_skip = ((ex_hosts.class == Array) ? ex_hosts : [ ex_hosts ]).compact

    hosts_to_skip.each do |h|
      if (h.class == Regexp) && ( h.match(request.host) )
        return false
      end
      if (h.class == String) && ( h.downcase == request.host.downcase )
        return false
      end
    end

    true
  end

  def logger
    @logger ||= ( defined?(Rails) ?
        Rails.logger :
        Logger.new(File.join(File.dirname(__FILE__), '../log/', "#{ENV['RACK_ENV'] || ENV['RAILS_ENV']}.log" ))
    )
  end

  def data_from_cookies(cookies)
    if cookies && cookies['http_client_info']
      JSON.parse(cookies['http_client_info'])
    end

  rescue => e
    logger.error("http_client_detector: extracting data from cookies failed: #{e.class} #{e.message}")
    nil
  end

  def data_from_service(user_agent)
    api_endpoint = @config[:url].dup
    if api_endpoint =~ /\/$/
      api_endpoint << 'debug'
    else
      api_endpoint << '/debug'
    end

    resp = RestClient.get(api_endpoint, { :accept => :json, :user_agent =>  user_agent, :experteer_service => 'client_detector'})

    JSON.parse(resp.body)

  rescue => e
    logger.error("http_client_detector: getting data from service failed: #{e.class} #{e.message}")
    nil
  end

end
