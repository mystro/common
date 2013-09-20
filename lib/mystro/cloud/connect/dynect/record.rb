require 'ipaddress'

module Mystro
  module Cloud
    module Dynect
      class Record < Connect
        manages 'Fog::DNS', :records

        def find(name)
          Mystro::Log.debug "find start"
          o = decode(fog.all.detect {|e| e.name == name})
          Mystro::Log.debug "find finish"
          o
        end

        def service
          @service ||= begin
            z = @config[:zone]
            s = zones.fog.all.detect {|e| e.domain == z}
            s
          end
        end

        protected

        def _decode(object)
          Mystro::Log.debug "decode: #{object.inspect}"
          model = Mystro::Cloud::Record.new
          #model.id = object.id
          model.name = object.name.gsub(/\.$/, '')
          model.values = [object.rdata]
          model.ttl = object.ttl
          model.type = object.type
          Mystro::Log.debug "decode: #{model.inspect}"
          model
        end

        def _encode(model)
          Mystro::Log.debug "encode: #{model.inspect}"
          n = model.name
          n += '.' unless n =~ /\.$/
          options = ::IPAddress.valid?(model.values.first) ?
              {name: n, value: model.values, type: 'A', ttl: model.ttl } :
              {name: model.name, value: model.values, type: 'CNAME', ttl: model.ttl }
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
