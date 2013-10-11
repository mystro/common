require 'ipaddress'
#require 'ext/fog/dynect/models/dns/records'

module Mystro
  module Cloud
    module Dynect
      class Record < Connect
        manages 'Fog::DNS', :records

        def find_by_name(name)
          #decode(fog.all.detect { |e| e.name == name })
          decode(service.send(collection).find_by_name(name).detect { |e| e.name == name })
        end

        def destroy(model)
          raise "destroy argument should be Mystro::Cloud::Model: #{model.inspect}" unless model.is_a?(Mystro::Cloud::Model)
          e = find_by_name(model.name)
          Mystro::Log.debug "destroy: #{e.inspect}"
          e._raw.destroy if e && e._raw
          service.publish
        end

        def service
          @service ||= begin
            list = zones.service.zones.all
            list.detect { |e| e.domain == @config[:zone] }
          end
        end

        def decode(object)
          return super unless object.is_a?(Array)
          list = super
          # filter out records that we don't need (TXT, etc)
          list.reject {|e| %w{A CNAME}.include?(e.type) }
          list
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
          model._raw = object
          Mystro::Log.debug "decode: #{model.inspect}"
          model
        end

        def _encode(model)
          Mystro::Log.debug "encode: #{model.type} #{model.inspect}"
          n = model.name
          n += '.' unless n =~ /\.$/
          options = model.type == 'A' ?
              {id: model.id, name: model.name, rdata: {'address' => model.values.first}, ttl: model.ttl, type: 'A'} :
              {id: model.id, name: model.name, rdata: {'cname' => model.values.first}, ttl: model.ttl, type: 'CNAME'}
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
