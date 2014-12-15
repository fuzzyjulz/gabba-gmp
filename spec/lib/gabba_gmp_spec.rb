require 'spec_helper'

describe GabbaGMP::GabbaGMP do
  describe "#initialize" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234, visitor_id: 567)}
    before do
      stub_analytics("")
    end
    
    #index, name, value
    it "#initialize(ga_tracking_id, request, cookies)" do
      gabba = GabbaGMP::GabbaGMP.new("tracker123", request, cookies)
      gabba.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker123", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action"}))
      
    end
    
    it "#initialize acceptLanguage" do
      request.accept_language = "da , en-gb;q=0.8, en;q=0.7"
      gabba = GabbaGMP::GabbaGMP.new("tracker123", request, cookies)
      gabba.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker123", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", ul: "da"}))
    end
    
    it "#initialize referrer" do
      request.referrer = "http://www.example.com/my-pages"
      gabba = GabbaGMP::GabbaGMP.new("tracker123", request, cookies)
      gabba.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker123", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action"}))

      request.referrer = "http://www.otherexample.com/my-pages"
      gabba = GabbaGMP::GabbaGMP.new("tracker123", request, cookies)
      gabba.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker123", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", dr: "http://www.otherexample.com/my-pages"}))
    end
    
    it "#initialize(ga_tracking_id, request, cookies, options = {})" do
      gabba = GabbaGMP::GabbaGMP.new("tracker123", request, cookies, client_id_cookie_sym: :visitor_id)
      gabba.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker123", cid: "567", t: "event", 
        ec: "Cats", ea: "Action"}))
    end
  end

  describe "#add_options" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    it "#add_options(options)" do
      gabbaGmp.add_options(user_language: "en-gb")
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", ul: "en-gb"}))
        
      gabbaGmp.add_options(dimension_1: "X", dimension_2: "Y", dimension_3: "Z")
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", ul: "en-gb", cd1: "X", cd2: "Y", cd3: "Z"}))

      gabbaGmp.set_custom_var(3, "Other Dimensions", "Time")
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", ul: "en-gb", cd1: "X", cd2: "Y", cd3: "Time"}))
    end
  end
  describe "#campaign=" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    it "#add_options(options)" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new()
      campaign.name = "First Campaign"
      campaign.source = "Bottle"
      campaign.medium = "Spiritual"
      campaign.keyword = "Ring"
      campaign.content = "Campaigns"
      
      gabbaGmp.campaign = campaign
      gabbaGmp.event("Cats1", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats1", ea: "Action", cn: "First Campaign", cs: "Bottle", cm: "Spiritual", ck: "Ring", cc: "Campaigns"}))

      gabbaGmp.campaign = nil
      gabbaGmp.event("Cats2", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats2", ea: "Action", cn: "First Campaign", cs: "Bottle", cm: "Spiritual", ck: "Ring", cc: "Campaigns"}))

      campaign = GabbaGMP::GabbaGMP::Campaign.new()
      campaign.keyword = "Rings"
      
      gabbaGmp.campaign = campaign
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", cn: "(direct)", cs: "(direct)", cm: "(none)", ck: "Rings"}))
        
      campaign = GabbaGMP::GabbaGMP::Campaign.new()
      campaign.content = "Contents"
      campaign.source = "Confidential"
      
      gabbaGmp.campaign = campaign
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", cn: "(direct)", cs: "Confidential", cm: "(none)", cc: "Contents"}))
    end
  end
  describe "#campaign=" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    it "@logger" do
      class LoggerClass
        attr_accessor :info_message
        def info(message)
          @info_message = message
        end
      end
      gabbaGmp.logger = LoggerClass.new
      gabbaGmp.event("Cats1", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats1", ea: "Action"}))
      expect(gabbaGmp.logger.info_message).to eq("GABBA_GMP: request params: v=1&tid=tracker&dh=www.example.com&cid=1234&uip=1.2.3.4&ua=Chrome%2F1.0.0.0.0&ul=en-us&t=event&ec=Cats1&ea=Action")
    end
  end
end