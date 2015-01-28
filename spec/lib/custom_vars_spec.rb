require 'spec_helper'

describe GabbaGMP::GabbaGMP::CustomVars do
  describe "#set_custom_var" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    
    #index, name, value
    
    it "#set_custom_var(index, name, value) using pageview" do
      gabbaGmp.set_custom_var(1, "Dogs", "Black")
      gabbaGmp.page_view(request)
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "pageview", cd1: "Black"}))
      
      #More custom vars in the same session
      gabbaGmp.set_custom_var(1, "Dog", "Spotty")
      gabbaGmp.set_custom_var(2, "Lemming", "Fall")
      gabbaGmp.set_custom_var(3, "Kite", "Surf")
      gabbaGmp.set_custom_var(200, "Cabbage", "Patch")
      gabbaGmp.page_view(request)
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "pageview", 
        cd1: "Spotty", cd2: "Fall", cd3: "Surf", cd200: "Patch"}))
      
      #Adding a custom var in between existing ones
      gabbaGmp.page_view(request, nil, dimension_4: "Ni!!")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "pageview", 
        cd1: "Spotty", cd2: "Fall", cd3: "Surf", cd200: "Patch", cd4: "Ni!!"}))
    end
    it "#set_custom_var(index, name, value) - raise an error if outside the valid range" do
      expect {gabbaGmp.set_custom_var(201, "Cabbage", "Patch")}.to raise_error(GabbaGMP::GoogleAnalyticsInvalidParameterError)
    end

    it "#set_custom_var(index, name, value) using event" do
      gabbaGmp.set_custom_var(1, "Dogs", "Black")
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", cd1: "Black"}))
      
      #More custom vars in the same session
      gabbaGmp.set_custom_var(1, "Letting type", "Let's Go")
      gabbaGmp.set_custom_var(2, "UFO", "Kite")
      gabbaGmp.set_custom_var(200, "Kite", "Surf")
      gabbaGmp.event("Cats", "Action")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", cd1: "Let's Go", cd2: "Kite", cd200: "Surf"}))

      #Adding a custom var in between existing ones
      gabbaGmp.event("Cats", "Action", nil, nil, dimension_3: "NOW!")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", tid: "tracker", cid: "1234", t: "event", 
        ec: "Cats", ea: "Action", cd1: "Let's Go", cd2: "Kite", cd200: "Surf", cd3: "NOW!"}))
      
    end
  end
end