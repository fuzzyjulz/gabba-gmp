module GabbaGMP
  class GabbaGMP
    class Campaign
      attr_accessor :name, :source, :medium, :keyword, :content
      
      def present?
        name.present? or source.present? or medium.present? or keyword.present? or content.present?
      end
    end
  end
end

