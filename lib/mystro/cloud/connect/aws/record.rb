module Mystro
  module Cloud
    module Aws
      class Record < Connect
        manages 'Fog::DNS', :records

        def service
          @service ||= begin
            z = @config[:zone]
            s = zones.fog.all.detect {|e| e.domain == "#{z}."}
            s
          end
        end

        protected

        def _decode(object)
          Mystro::Log.debug "decode: #{object.inspect}"
          model = Mystro::Cloud::Record.new
          model.name = object.name
          model.values = object.value
          model.ttl = object.ttl
          model.type = object.type
          Mystro::Log.debug "decode: #{model.inspect}"
          model
        end

        def _encode(model)
          raise "write me"
          Mystro::Log.debug "encode: #{model.inspect}"
          options = {
              image_id: model.image,
              flavor_id: model.flavor,
              key_name: model.keypair,
              groups: model.groups,
              region: model.region,
              user_data: model.userdata,
          }
          Mystro::Log.debug "encode: #{options.inspect}"
          options
        end

        private

        def zones
          Mystro::Cloud::Aws::Zone.new(@options, @config)
        end
      end
    end
  end
end
