module Mystro
  module Cloud
    module Aws
      class Balancer < Connect
        manages 'Fog::Balancer', :load_balancers

        def create(model)
          list = model.computes
          enc = encode(model)
          bal = service.send(collection).create(enc)
          bal.register_instances(list)
          bal.save
          decode(bal)
        end

        protected

        def _decode(balancer)
          model = Mystro::Cloud::Balancer.new
          model.id = balancer.id
          model.dns = balancer.dns_name
          model.computes = balancer.instances
          model.zones = balancer.availability_zones
          model.health = balancer.health_check

          decoded = []
          balancer.listeners.each do |l|
            decoded << listeners.decode(l)
          end
          model.listeners = decoded

          model._raw = balancer
          model
        end

        def _encode(model)
          Mystro::Log.debug "encode < #{model.inspect}"
          o = {
              id: model.id,
              'ListenerDescriptions' => model.listeners.map {|l| listeners.encode(l)},
              'AvailabilityZones' => model.zones
          }
          Mystro::Log.debug "encode > #{o.inspect}"
          o
        end

        private

        def listeners
          @listeners ||= Mystro::Cloud::Aws::Listener.new(options)
        end
      end
    end
  end
end
