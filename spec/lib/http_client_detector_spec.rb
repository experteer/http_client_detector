require 'spec_helper'

describe 'DetectorApp' do

  let(:iphone) {
    'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X; en-us) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53'
  }

  let(:iphone_info) {
    {:status => 'ok', :phone => true, :robot => false}
  }

  describe 'get iphone client info' do
    before(:each) do
      request_headers_expected = {'User-Agent'=> iphone}
      response_body_mock = {:status => 'ok', :phone => true, :robot => false}.to_json

      service_request = stub_request(:get, RSpec.configuration.detector_test_url).
                         with(:headers => request_headers_expected).to_return( :body => response_body_mock  )

      get '/', {}, 'HTTP_USER_AGENT' => iphone

      service_request.should have_been_requested
    end


    it 'should respond with status 200' do
      last_response.status.should == 200
    end

    describe 'response body' do
      subject{ JSON.parse(last_response.body) }

      its(['status']){ should == iphone_info[:status] }
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

      its(['status']){ should == 'error' }
      its(['message']){ should == '500 Internal Server Error' }
      its(['service_response']){ should == 'service not responding' }

    end

  end

end