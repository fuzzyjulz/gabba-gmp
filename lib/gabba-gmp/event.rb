module GabbaGMP
  class GabbaGMP
    module Event
      # Public: Record an event in Google Analytics
      # (https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide)
      #
      # category::  
      # action::    
      # label::     
      # value::     
      # options::   Optional. Any additional parameters to send with the page view
      #
      # Example:
      #
      #   g.event("Videos", "Play", "ID", "123")
      #
      def event(category, action, label = nil, value = nil, options = {})
        hey(event_params(category, action, label, value, options))
      end

      # Public: Renders event params data in the format needed for GA
      # Called before actually sending the data along to GA in GabbaGMP#event
      def event_params(category, action, label, value, event_options)
        options = {
          hit_type: "event",
          event_category: category,
          event_action: action
        }
        options[:event_label] = label if label.present?
        options[:event_value] = value if value.present?
        @sessionopts.merge(options).merge!(event_options)
      end
    end
  end
end