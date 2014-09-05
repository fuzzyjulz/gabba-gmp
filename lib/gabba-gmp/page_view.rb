module GabbaGMP
  class GabbaGMP
    module PageView
      # Public: Record a page view in Google Analytics
      #
      # title   - String with the page title for thr page view
      # page    - String with the path for the page view
      #
      # Example:
      #
     #   g.page_view("page title", "page/1.html")
      #
      def page_view(title, page)
        check_account_params
        hey(page_view_params(title, page))
      end

      # Public: Renders the page view params data in the format needed for GA
      # Called before actually sending the data along to GA.
      def page_view_params(title, page)
        @sessionopts.merge({
          t: "pageview",
          dt: title,
          dp: page
        })
      end
    end
  end
end