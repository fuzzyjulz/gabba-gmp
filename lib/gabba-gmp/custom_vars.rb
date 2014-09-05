module GabbaGMP
  class GabbaGMP
    module CustomVars
      # Public: Set a custom variable to be passed along and logged by Google Analytics
      # (http://code.google.com/apis/analytics/docs/tracking/gaTrackingCustomVariables.html)
      #
      # index  - Integer between 1 and 50 for this custom variable (limit is 5 normally, but is 50 for GA Premium)
      # name   - String with the name of the custom variable
      # value  - String with the value for teh custom variable
      #
      # Example:
      #
      #   g.set_custom_var(1, 'awesomeness', 'supreme')
      #
      # Returns array with the custom variable data
      def set_custom_var(index, name, value)
        raise "Index must be between 1 and 50" unless (1..50).include?(index)
        
        @sessionopts["cd#{index}".to_sym] = value
      end
    end
  end
end