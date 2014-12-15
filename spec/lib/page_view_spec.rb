require 'spec_helper'
require 'pry'

describe GabbaGMP::GabbaGMP::PageView do
  describe "#page_view" do
    let(:request) {MockRequest.new}
    let(:cookies) {MockCookies.new(utm_visitor_uuid: 1234)}
    let(:gabbaGmp) { GabbaGMP::GabbaGMP.new("tracker", request, cookies)}
    before do
      stub_analytics("")
    end
    
    #request, title = nil, options = {}
    
    it "#page_view(request)" do
      gabbaGmp.page_view(request)
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "", tid: "tracker", cid: "1234", t: "pageview", dp: ""}))

      request.fullpath = "/amazing/things"
      gabbaGmp.page_view(request)
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "", tid: "tracker", cid: "1234", t: "pageview", dp: "/amazing/things"}))
    end
    
    it "#page_view(request, title)" do
      gabbaGmp.page_view(request, "Title")
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "Title", tid: "tracker", cid: "1234", t: "pageview", dp: ""}))
    end
    
    it "#page_view(request, title, options)" do
      gabbaGmp.page_view(request, "Title", {document_path: "/Nowhere"})
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "Title", tid: "tracker", cid: "1234", t: "pageview", dp: "/Nowhere"}))
    end
    
    it "must not interfere with other calls if using options" do
      gabbaGmp.page_view(request, "Title", {document_path: "/Nowhere"})
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "Title", tid: "tracker", cid: "1234", t: "pageview", dp: "/Nowhere"}))

      gabbaGmp.page_view(request)
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "", tid: "tracker", cid: "1234", t: "pageview", dp: ""}))

      gabbaGmp.page_view(request, "Title", {user_language: "en-au"})
      expect_query(MockRequest::DEFAULT_PARAMS.merge({v: "1", dt: "Title", tid: "tracker", cid: "1234", t: "pageview", ul: "en-au", dp: ""}))
    end
  end
end