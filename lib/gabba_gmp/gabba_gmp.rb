# yo, easy server-side tracking for Google Analytics... hey!
require 'uri'
require 'net/http'
require 'ipaddr'
require 'cgi'
require 'net/http/persistent'

require "#{File.dirname(__FILE__)}/campaign"
require "#{File.dirname(__FILE__)}/custom_vars"
require "#{File.dirname(__FILE__)}/event"
require "#{File.dirname(__FILE__)}/page_view"
require "#{File.dirname(__FILE__)}/version"

module GabbaGMP

  class NoGoogleAnalyticsAccountError < RuntimeError; end
  class NoGoogleAnalyticsDomainError < RuntimeError; end
  class GoogleAnalyticsNetworkError < RuntimeError; end

  class GabbaGMP
    GOOGLE_HOST = "www.google-analytics.com"
    BEACON_PATH = "/collect"
    USER_AGENT = "Gabba GMP #{VERSION} Agent"

    include CustomVars
    include Event
    include PageView

    ESCAPES = %w{ ' ! * ) }

    attr_accessor :debug

    # Public: Initialize Gabba Google Analytics Tracking Object.
    #
    # ga_acct - A String containing your Google Analytics account id.
    # domain  - A String containing which domain you want the tracking data to be logged from.
    # visitor_uuid - a uuid to uniquely identify the user - use SecureRandom.uuid to generate
    # client_ip - The IP address of the connected client
    # agent   - A String containing the user agent you want the tracking to appear to be coming from.
    #           Defaults to "Gabba 0.2 Agent" or whatever the correct version is.
    # Example:
    #
    #   g = GabbaGMP::GabbaGMP.new("UT-1234", "mydomain.com")
    #
    def initialize(ga_acct, domain, visitor_uuid, client_ip, agent = nil)
      agent =  agent.present? ? agent : GabbaGMP::USER_AGENT
      
      @sessionopts = {v: 1, tid: ga_acct.to_s, dh: domain.to_s, cid: visitor_uuid.to_s, uip: client_ip.to_s, ua: agent.to_s}
        
      debug = false
    end


    # Public: provide the utmr attribute, allowing for referral tracking
    #
    # Called before page_view etc
    #
    # Examples:
    #   g.referer(request.env['HTTP_REFERER'])
    #   g.page_view("something", "track/me")
    #
    def referer(referrer)
      @sessionopts[:dr] = referrer
      self
    end

    def campaign=(campaign)
      campaign ||= Campaign.new
      {}.tap do |campaign_params|
        @sessionopts[:cn] = campaign.name
        @sessionopts[:cn] ||= "(direct)"
          
        @sessionopts[:cs] = campaign.source
        @sessionopts[:cs] ||= "(direct)"
          
        @sessionopts[:cm] = campaign.medium
        @sessionopts[:cm] ||= "(none)"
          
        @sessionopts[:ck] = campaign.keyword if campaign.keyword.present?
          
        @sessionopts[:cc] = campaign.content if campaign.content.present?
      end
    end
    
    # sanity check that we have needed params to even call GA
    def check_account_params
    end

    # makes the tracking call to Google Analytics
    def hey(params)
      query = params.map {|k,v| "#{k}=#{URI.escape(v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}" }.join('&')

      @http ||= Net::HTTP::Persistent.new 'GabbaGMP'

      Rails.logger.info "GABBA_GMP: request params: #{query}" if debug
      
      request = Net::HTTP::Get.new("#{BEACON_PATH}?#{query}")
      request["User-Agent"] = URI.escape(params[:ua])
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

