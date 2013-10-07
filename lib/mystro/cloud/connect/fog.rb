require 'fog'
require 'mystro/ext/fog/balancer'

module Mystro
  module Cloud
    module Fog
      class Connect < Mystro::Cloud::Connect
        attr_reader :options

        def initialize(options, config=nil)
          @options = options
          @config = config
          @service = nil
          @fog = nil
        end

        def all
          decode(service.send(collection).all)
        end

        def find(id)
          i = service.send(collection).get(id)
          raise Mystro::Cloud::NotFound, "could not find #{id}" unless i
          decode(i)
        end

        def create(model)
          enc = encode(model)
          o = service.send(collection).create(enc)
          decode(o)
        end

        def destroy(model)
          id = model.is_a?(Mystro::Cloud::Model) ? model.identity : model
          e = service.send(collection).get(id)
          #Mystro::Log.debug "destroy: #{e.inspect}"
          e.destroy
        end

        def collection
          @collection ||= self.class.collection
        end

        def service
          @service ||= begin
            model = self.class.model
            s = model.constantize.new(@options)
            s
          end
        end

        #def fog
        #  @fog ||= begin
        #    collection = self.class.collection
        #    s = service.send(collection)
        #    s
        #  end
        #end

        class << self
          attr_reader :model, :collection

          protected

          def manages(fog_model, fog_collection)
            @model = fog_model
            @collection = fog_collection
          end
        end
      end
    end
  end
end
