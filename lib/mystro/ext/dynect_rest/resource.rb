class DynectRest
  class AnyResource

    attr_accessor :dynect, :zone

    def initialize(dynect, zone)
      @dynect = dynect
      @zone = zone
      @record_type = 'ANY'
    end

    def get(fqdn)
      results = @dynect.get("#{@record_type}Record/#{@zone}/#{fqdn}")
      raw_rr_list = results.map do |record|
        if (record =~ /^\/REST\/(\w+)Record\/#{@zone}\/#{Regexp.escape(fqdn)}\/(\d+)$/)
          DynectRest::Resource.new(@dynect, $1, @zone).get(fqdn, $2)
        else
          record
        end
      end
      case raw_rr_list.length
        when 0
          raise DynectRest::Exceptions::RequestFailed, "Cannot find #{@record_type} record for #{fqdn}"
        when 1
          raw_rr_list[0]
        else
          raw_rr_list
      end
    end
  end
end
