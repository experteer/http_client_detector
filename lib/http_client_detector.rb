class HttpClientDetector

  def initialize(app, config={ })
    @app=app
    @config = config
  end

  def call(env)
    user_agent = env['HTTP_USER_AGENT']
    info = get_info_from_service(user_agent)
    env['rack.http_client_info'] = info
    @app.call(env)
  end


  private

  def get_info_from_service(user_agent)
   # { :status => 'success', :ua => user_agent }
    response_body = RestClient.get(@config[:url], { :accept => :json, :user_agent =>  user_agent}).body

    JSON.parse(response_body)

  rescue => e
    {:status => 'error', :service_response => e.response, :message => e.message }
  end

end