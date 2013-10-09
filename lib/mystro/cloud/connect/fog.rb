require 'fog'
require 'fog/ext/balancer'

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
          raise "destroy argument should be Mystro::Cloud::Model: #{model.inspect}" unless model.is_a?(Mystro::Cloud::Model)
          e = service.send(collection).get(model.id)
          e.destroy if e
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
