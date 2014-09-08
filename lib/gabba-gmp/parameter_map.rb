module GabbaGMP
  class GabbaGMP
    DIMENSION_MAX = 200
    module ParameterMap
      GA_PARAMS = {
        protocol_version: :v,
        tracking_id: :tid,

        user_ip_address: :uip,
        client_id: :cid,
        user_agent: :ua,

        hit_type: :t,
        
        document_title: :dt,
        document_path: :dp,
        document_referrer: :dr,
        document_host: :dh,
        
        event_category: :ec,
        event_action: :ea,
        event_label: :el,
        event_value: :ev,
        
        campaign_name: :cn,
        campaign_source: :cs,
        campaign_medium: :cm,
        campaign_keyword: :ck,
        campaign_content: :cc
        
      }.merge(Hash[(1..GabbaGMP::DIMENSION_MAX).map {|index| ["dimension_#{index}".to_sym, "cd#{index}".to_sym]}])
    end
  end
end
