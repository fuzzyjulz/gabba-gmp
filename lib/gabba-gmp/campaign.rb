module GabbaGMP
  class GabbaGMP
    class Campaign
      attr_accessor :name, :source, :medium, :keyword, :content
      
      def present?
        !name.to_s.empty? or !source.to_s.empty? or !medium.to_s.empty? or !keyword.to_s.empty? or !content.to_s.empty?
      end
    end
  end
end

