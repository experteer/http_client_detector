require 'http_client_info'
require 'cgi'
require 'json'
require 'logger'

class HttpClientDetector

  def initialize(app, config={ })
    @app=app
    @config = config
  end

  def call(env)
    # puts env.inspect
    info = Rack::HttpClientInfo.new.load_from_raw_data( data_from_cookies(env['HTTP_COOKIE']) )
    unless info.verified?
      info = Rack::HttpClientInfo.new.load_from_raw_data(  data_from_service(env['HTTP_USER_AGENT']) )
      #if info.verified?
      #  env['HTTP_COOKIE'] ||= ''
      #  env['HTTP_COOKIE'] = (serialize_data_for_cookies( info ) + env['HTTP_COOKIE'])
      #  logger.debug "http_client_detector: COOKIES UPDATED: #{ env['HTTP_COOKIE'] }"
      #end
    end


    # logger.debug "http_client_detector: COOKIES JAR: #{ env['action_dispatch.cookies'].inspect }"

    env['rack.http_client_info'] = info

    @app.call(env)
  end


  private

  def logger
    @logger ||= ( defined?(Rails) ?
        Rails.logger :
        Logger.new(File.join(File.dirname(__FILE__), '../log/', "#{ENV['RACK_ENV'] || ENV['RAILS_ENV']}.log" ))
    )
  end

  def serialize_data_for_cookies(data)
    value = CGI.escape( data.to_json )
    "http_client_info=#{value}; "
  end

  def data_from_cookies(cookies)
    matched = /http_client_info=(.+?)(;|$)/.match(cookies.to_s)
    data = nil
    if matched && matched[1]
      logger.debug "http_client_detector: COOKIES CONTAIN: #{ matched[1] }"
      raw_data = CGI.unescape( matched[1] )
      data = JSON.parse(raw_data)
    end

    data || { :status => 'error', :message => 'Cookies empty' }
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