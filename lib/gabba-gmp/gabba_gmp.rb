# yo, easy server-side tracking for Google Analytics... hey!
require 'uri'
require 'net/http'
require 'ipaddr'
require 'cgi'
require 'net/http/persistent'

require "#{File.dirname(__FILE__)}/parameter_map"
require "#{File.dirname(__FILE__)}/campaign"
require "#{File.dirname(__FILE__)}/custom_vars"
require "#{File.dirname(__FILE__)}/event"
require "#{File.dirname(__FILE__)}/page_view"
require "#{File.dirname(__FILE__)}/version"

module GabbaGMP

  class GoogleAnalyticsInvalidParameterError < RuntimeError; end
  class GoogleAnalyticsRequiredParameterMissingError < RuntimeError; end
  class GoogleAnalyticsParameterNotFoundError < RuntimeError; end
  class NoGoogleAnalyticsAccountError < RuntimeError; end
  class NoGoogleAnalyticsDomainError < RuntimeError; end
  class GoogleAnalyticsNetworkError < RuntimeError; end

  class GabbaGMP
    GOOGLE_HOST = "www.google-analytics.com"
    BEACON_PATH = "/collect"
    USER_AGENT = "Gabba GMP #{VERSION} Agent"

    include ParameterMap
    include CustomVars
    include Event
    include PageView

    ESCAPES = %w{ ' ! * ) }

    attr_accessor :debug

    # Public: Initialize Gabba Google Analytics Tracking Object.
    #
    # ga_tracking_id  - A String containing your Google Analytics account id.
    # request         - The request this tracker relates to.
    # cookies         - The cookies object for this request. Will be updated with the client_id cookie
    # options         - Allows for:
    #                           -client_id_cookie_expiry = Set the expiry of the visitor cookie manually
    #                           -client_id_cookie_sym = The symbol to store the visitor id cookie under
    # Example:
    #
    #   g = GabbaGMP::GabbaGMP.new("UT-1234", "mydomain.com")
    #
    def initialize(ga_tracking_id, request, cookies, options = {})
      client_id_cookie = options[:client_id_cookie_sym]
      client_id_cookie = :utm_visitor_uuid if !client_id_cookie.present? or !client_id_cookie.kind_of? Symbol
      
      if !cookies[client_id_cookie].present?
        cookie_expiry = options[:client_id_cookie_expiry] ? options[:client_id_cookie_expiry] : 1.year.from_now
        cookies[client_id_cookie] = { value: "#{SecureRandom.uuid}", expires: cookie_expiry}
      end
      
      @sessionopts = {protocol_version: 1, 
                      tracking_id: ga_tracking_id, 
                      document_host: request.host, 
                      client_id: cookies[client_id_cookie], 
                      user_ip_address: request.remote_ip, 
                      user_agent: request.user_agent,
                      user_language: preferred_language(request.accept_language)}
        
      @sessionopts[:document_referrer] = request.referrer if request.referrer.present?
        
      debug = false
    end

    def preferred_language(language)
      return "" unless language.present?
      
      language_arr = language.split(",").map {|lang_pref| lang_pref.split(";")}
      language_arr[0][0].downcase #just get the first language. Will probably be correct.
    end

    # Public: Set the session's parameters. This will be added to all actions that are sent to analytics.
    #  
    #  See::  ParameterMap:GA_PARAMS
    def add_options(options)
      options.keys.each do |key| 
        raise GoogleAnalyticsParameterNotFoundError, "Parameter '#{key}'" unless GA_PARAMS[key].present?
      end
      
      @sessionopts.merge!(options)
      self
    end

    # Public: Set the campaign details from a campaign object. You can also use your own Campaign object so long
    #  as they support the 5 methods (name, source, medium, keyword, content)
    def campaign=(campaign)
      campaign ||= Campaign.new
      {}.tap do |campaign_params|
        @sessionopts[:campaign_name] = campaign.name
        @sessionopts[:campaign_name] ||= "(direct)"
          
        @sessionopts[:campaign_source] = campaign.source
        @sessionopts[:campaign_source] ||= "(direct)"
          
        @sessionopts[:campaign_medium] = campaign.medium
        @sessionopts[:campaign_medium] ||= "(none)"
          
        @sessionopts[:campaign_keyword] = campaign.keyword if campaign.keyword.present?
          
        @sessionopts[:campaign_content] = campaign.content if campaign.content.present?
      end
    end
    
    # Sanity check that we have needed params to even call GA
    def validate_session_parameters(params)
      raise GoogleAnalyticsRequiredParameterMissingError, "Protocol version is required" unless params[:protocol_version].present?
      raise GoogleAnalyticsRequiredParameterMissingError, "Tracking id is required" unless params[:tracking_id].present?
      raise GoogleAnalyticsRequiredParameterMissingError, "Client id is required" unless params[:client_id].present?
      raise GoogleAnalyticsRequiredParameterMissingError, "Hit type is required" unless params[:hit_type].present?
      
      params.keys.each do |param|
        raise GoogleAnalyticsInvalidParameterError, "The parameter '#{param}' is not currently recognised." unless GA_PARAMS[param].present?
      end
    end

    # makes the tracking call to Google Analytics
    def hey(params)
      validate_session_parameters(params)
      query = params.map {|k,v| "#{GA_PARAMS[k]}=#{URI.escape("#{v}", Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}" }.join('&')

      @http ||= Net::HTTP::Persistent.new 'GabbaGMP'

      Rails.logger.info "GABBA_GMP: request params: #{query}" if debug
      
      request = Net::HTTP::Get.new("#{BEACON_PATH}?#{query}")
      request["User-Agent"] = URI.escape(params[:user_agent])
      request["Accept"] = "*/*"
      uri = URI "http://#{GOOGLE_HOST}/#{BEACON_PATH}"
      response = @http.request(uri, request)

      raise GoogleAnalyticsNetworkError unless response.code == "200"
      response
    end

    def escape(t)
      return t if !t || (/\w/ !~ t.to_s)

      t.to_s.gsub(/[\*'!\)]/) do |m|
        "'#{ESCAPES.index(m)}"
      end
    end
  end
end

