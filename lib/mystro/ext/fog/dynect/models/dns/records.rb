module Fog
  module DNS
    class Dynect
      class Records < Fog::Collection
        def find_by_name(name)
          requires :zone
          data = []
          service.get_all_records(zone.domain, options).body['data'].select { |url| url =~ /\/#{name}\// }.each do |url|
            (_, _, t, _, fqdn, id) = url.split('/')
            type = t.gsub(/Record$/, '')

            # leave out the default, read only records
            next if ['NS', 'SOA'].include?(type)

            record = service.get_record(type, zone.domain, fqdn, 'record_id' => id).body['data']

            data << {
                :identity => record['record_id'],
                :fqdn => record['fqdn'],
                :type => record['record_type'],
                :rdata => record['rdata']
            }
          end

          load(data)
        end
      end
    end
  end
end