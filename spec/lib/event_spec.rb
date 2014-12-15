require 'spec_helper'
require 'pry'

describe GabbaGMP::GabbaGMP::Event do
  describe "#event" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    
    #category, action, label = nil, value = nil, options = {}
    
    it "#event(category, action)" do
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action"}))
    end
    
    it "#event(category, action, label)" do
      gabbaGmp.event("Cats", "Action", "Label")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label"}))
    end

    it "#event(category, action, label, value)" do
      gabbaGmp.event("Cats", "Action", "Label", "Value")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label", ev: "Value"}))
    end

    it "#event(category, action, label, value, options)" do
      gabbaGmp.event("Cats", "Action", "Label", "Value", user_language: "en-au")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label", ev: "Value", ul: "en-au"}))
    end
    
    it "must not interfere with other calls if using options" do
      gabbaGmp.event("Cats", "Action", "Label", "Value", user_language: "en-au")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label", ev: "Value", ul: "en-au"}))
      
      gabbaGmp.event("Cats", "Action", "Label", "Value")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label", ev: "Value"}))

      gabbaGmp.event("Cats", "Action", "Label", "Value", document_path: "/path")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", el: "Label", ev: "Value", dp: "/path"}))

    end
  end
end