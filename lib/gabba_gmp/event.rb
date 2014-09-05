module GabbaGMP
  class GabbaGMP
    module Event
      # Public: Record an event in Google Analytics
      # (https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide)
      #
      # category  -
      # action    -
      # label     -
      # value     -
      #
      # Example:
      #
      #   g.event("Videos", "Play", "ID", "123")
      #
      def event(category, action, label = nil, value = nil)
        check_account_params
        hey(event_params(category, action, label, value))
      end

      # Public: Renders event params data in the format needed for GA
      # Called before actually sending the data along to GA in GabbaGMP#event
      def event_params(category, action, label = nil, value = nil)
        options = {
          t: "event",
          ec: category,
          ea: action
        }
        options[:el] = label if label.present?
        options[:ev] = value if value.present?
        @sessionopts.merge(options)
      end
    end
  end
end