module GabbaGMP
  class GabbaGMP
    module CustomVars
      # Public: Set a custom variable to be passed along and logged by Google Analytics
      # (http://code.google.com/apis/analytics/docs/tracking/gaTrackingCustomVariables.html)
      #
      # index  - Integer between 1 and 200 for this custom dimension (limit is 20 normally, but is 200 for GA Premium)
      # name   - String with the name of the custom dimension
      # value  - String with the value for the custom dimension
      #
      # Example:
      #
      #   g.set_custom_var(1, 'awesomeness', 'supreme')
      #
      # Returns array with the custom variable data
      def set_custom_var(index, name, value)
        raise "Index must be between 1 and #{GabbaGMP::DIMENSION_MAX}" unless (1..GabbaGMP::DIMENSION_MAX).include?(index)
        
        @sessionopts["dimension_#{index}".to_sym] = value
      end
    end
  end
end