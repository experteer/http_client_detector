require 'spec_helper'

describe 'DetectorApp' do

  let(:iphone) {
    'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X; en-us) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53'
  }

  let(:iphone_info) {
    {:verified => true, :phone => true, :robot => false}
  }

  describe 'exclude-host behavior with regexp ^api' do

    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).
          with(:headers => request_headers_expected).to_return( :body => iphone_info.to_json  )

      set_cookie 'testkey=testvalue'
      get 'http://api.experteer.com/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should_not have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end
  end

  describe 'exclude-host behavior with string admin.experteer.de' do

    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).to_return( :body => iphone_info.to_json  )

      get 'http://admin.Experteer.de/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should_not have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end
  end


  describe 'bypass POST requests' do

    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).to_return( :body => iphone_info.to_json  )

      post '/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should_not have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end
  end

  describe 'get http_client_info from webservice' do
    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone,  'Experteer-Service' => 'client_detector'}

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).
                         with(:headers => request_headers_expected).to_return( :body => iphone_info.to_json  )

      set_cookie 'testkey=testvalue'
      get '/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end

    describe 'response body' do
      subject{ JSON.parse(last_response.body) }

      its(['verified']){ should == iphone_info[:verified] }
      its(['phone']){ should == iphone_info[:phone] }
      its(['robot']){ should == iphone_info[:robot] }

    end

    describe 'response headers' do
      subject{ last_response.headers }

      its(['Set-Cookie']){should match(/http_client_info=.+;/)}
    end

    describe 'response header Set-Cookie http_client_info' do
      subject{ JSON.parse(CGI.unescape /http_client_info=(.+?);/.match(last_response.headers['Set-Cookie'])[1]) }

      it {should == {'phone'=>true, 'verified'=>true, 'robot'=>false} }
    end

  end

  describe 'get http_client_info from cookies' do
    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}
      response_body_mock = {:status => 'ok', :phone => true, :robot => false}.to_json

      service_request = stub_request(:get, RSpec.configuration.detector_test_url)

      set_cookie "http_client_info=#{ CGI.escape(iphone_info.to_json) }"
      get '/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should_not have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end

    describe 'response body' do
      subject{ JSON.parse(last_response.body) }

      its(['verified']){ should == iphone_info[:verified] }
      its(['phone']){ should == iphone_info[:phone] }
      its(['robot']){ should == iphone_info[:robot] }

    end
  end


  describe 'service failure' do
    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).
          with(:headers => request_headers_expected).to_return( :status => 500, :body => 'service not responding'  )

      get '/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end

    describe 'response body' do
      subject{ JSON.parse(last_response.body) }

      its(['verified']){ should == false }
      its(['phone']){ should == false }
      its(['robot']){ should == false }

    end

  end

end