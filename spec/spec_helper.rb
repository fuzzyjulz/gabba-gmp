require 'gabba-gmp'
require 'rspec'

require 'webmock/rspec'
WebMock.disable_net_connect!

def stub_analytics(expected_params)
  stub_request(
    :get,
    /www.google-analytics.com\/collect?#{expected_params}/
  ).to_return(:status => 200, :body => '', :headers => {})
end

def expect_query(query_params)
  expect(WebMock).to have_requested(:get, "www.google-analytics.com\/collect").with(:query => query_params)
end

class MockCookies
  def initialize(cookieSet = {})
    @cookieList = cookieSet
  end
  
  def [](key)
    @cookieList[key]
  end
  def []=(key, value)
    @cookieList[key] = value[:value]
  end
end
class MockRequest
  DEFAULT_PARAMS = {dh: "www.example.com", 
                    uip: "1.2.3.4",
                    ua: "Chrome/1.0.0.0.0",
                    ul: "en-us",
                    }
  attr_accessor :host, :remote_ip, :user_agent, :accept_language, :referrer, :fullpath, :protocol, :host_with_port
  
  def initialize()
    @host = DEFAULT_PARAMS[:dh]
    @remote_ip = DEFAULT_PARAMS[:uip]
    @user_agent = DEFAULT_PARAMS[:ua]
    @accept_language = DEFAULT_PARAMS[:ul]
    @referrer = DEFAULT_PARAMS[:dr]
    @fullpath = DEFAULT_PARAMS[:dp]
    @protocol = "http://"
    @host_with_port = "www.example.com"
  end
end
