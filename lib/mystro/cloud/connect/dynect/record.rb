require 'ipaddress'
require 'mystro/ext/fog/dynect/models/dns/records'

module Mystro
  module Cloud
    module Dynect
      class Record < Connect
        manages 'Fog::DNS', :records

        def find(name)
          decode(fog.all.detect { |e| e.name == name })
          #decode(fog.find_by_name(name).detect { |e| e.name == name })
        end

        def service
          @service ||= begin
            z = @config[:zone]
            zones.fog.all.detect { |e| e.domain == z }
          end
        end

        def decode(object)
          raise "decode: object is nil" unless object
          object.is_a?(Array) ? object.select { |e| %w{A CNAME}.include?(e.type) }.map { |e| _decode(e) } : _decode(object)
        end

        protected

        def _decode(object)
          Mystro::Log.debug "decode: #{object.inspect}"
          model = Mystro::Cloud::Record.new
          model.id = object.id
          model.name = object.name.gsub(/\.$/, '')
          model.values = [object.type == 'CNAME' ? object.rdata['cname'] : object.rdata['address']]
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
              {name: n, value: model.values, type: 'A', ttl: model.ttl} :
              {name: model.name, value: model.values, type: 'CNAME', ttl: model.ttl}
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
