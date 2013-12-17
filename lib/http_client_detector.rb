require 'http_client_info'
require 'cgi'
require 'json'

class HttpClientDetector

  def initialize(app, config={ })
    @app=app
    @config = config
  end

  def call(env)
    # puts env.inspect
    info = Rack::HttpClientInfo.new.load_from_raw_data( data_from_cookies(env['HTTP_COOKIE']) )
    unless info.ok?
      info = Rack::HttpClientInfo.new.load_from_raw_data(  data_from_service(env['HTTP_USER_AGENT']) )
    end

    env['rack.http_client_info'] = info

    if info.ok?
      env['HTTP_COOKIE'] ||= ''
      env['HTTP_COOKIE'] = (serialize_data_for_cookies( info ) + env['HTTP_COOKIE'])
    end



    @app.call(env)
  end


  private


  def serialize_data_for_cookies(data)
    value = CGI.escape( data.to_json )
    "http_client_info=#{value}; "
  end

  def data_from_cookies(cookies)
    matched = /http_client_info=(.+?)(;|$)/.match(cookies.to_s)
    data = nil
    if matched && matched[1]
      raw_data = CGI.unescape( matched[1] )
      data = JSON.parse(raw_data)
    end

    data || { :status => 'error', :message => 'Cookies empty' }
  rescue => e
    {:status => 'error', :message => "Extracting data from cookies failed: #{e.message}" }
  end

  def data_from_service(user_agent)
   # { :status => 'success', :ua => user_agent }
    response_body = RestClient.get(@config[:url], { :accept => :json, :user_agent =>  user_agent}).body

    JSON.parse(response_body)

  rescue => e
    {:status => 'error', :service_response => e.response, :message => e.message }
  end

end