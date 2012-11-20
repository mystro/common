
module Mystro
  module Connect
    class Dns < Base
      self.model      = "Fog::DNS"
      self.collection = :records

      def find_by_endpoint(dns)
        all.select {|e| [*e.value].flatten.include?(dns)}
      end

      # customize the connect function, because we are defaulting
      # to the zone from the configuration
      def connect
        @fog ||= begin
          raise "could not connect to DNS; #{opt.to_hash.inspect}; #{cfg.to_hash.inspect}" unless opt && cfg.zone
          dns = Fog::DNS.new(opt)
          dns.zones.find(cfg.zone).first
        end
      rescue => e
        Mystro::Log.error "DNS connect failed: #{e.message} at #{e.backtrace.first}"
      end

      def zones
        Fog::DNS.new(opt).zones.all
      end

      def zone(name)
        Fog::DNS.new(opt).zones.find(name).first
      end

      def create_zone(model)
        Fog::DNS.new(opt).zones.create(model.fog_options)
      end
    end
  end
end