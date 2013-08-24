
module Mystro
  module Connect
    class Dns < Base
      self.model      = "Fog::DNS"
      self.collection = :records

      def find_by_endpoint(dns)
        all.select {|e| [*e.value].flatten.include?(dns)}
      end

      def find_by_name(name)
        connection.zones.all.detect {|e| e.domain == name}
      end

      # customize the connect function, because we are defaulting
      # to the zone from the configuration
      def connect
        @fog ||= begin
          raise "must set zone" unless cfg.zone
          raise "must set options" unless opt
          find_by_name(cfg.zone)
        end
      rescue => e
        Mystro::Log.error "DNS connect failed: #{e.message} at #{e.backtrace.first}"
        Mystro::Log.error e
      end

      def connection
        Fog::DNS.new(opt.to_hash.symbolize_keys)
      end

      def zones
        connection.zones.all
      end

      def zone(name)
        n = "#{name}."
        z = connection.zones.get(n)
        raise("zone #{n} not found") unless z
        z
      rescue => e
        raise("#{e.message} at #{e.backtrace.first}")
      end

      def create_zone(model)
        connection.zones.create(model.fog_options)
      end
    end
  end
end
