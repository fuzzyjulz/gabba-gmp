module GabbaGMP
  class GabbaGMP
    module PageView
      # Public: Record a page view in Google Analytics
      #
      # request:: String with the path for the page view
      # title::   Optional. String with the page title for the page view
      # options:: Optional. Any additional parameters to send with the page view
      #
      # Example:
      #
      #   g.page_view(request, "page title")
      #
      def page_view(request, title = nil, options = {})
        
        send(page_view_params(title, request.fullpath, options))
      end

      private
      # Private: Renders the page view params data in the format needed for GA
      # Called before actually sending the data along to GA.
      def page_view_params(title, doc_path, options)
        @sessionopts.merge({
          hit_type: "pageview",
          document_title: title,
          document_path: doc_path
        }).merge!(options)
      end
    end
  end
end