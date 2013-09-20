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
          decode(fog.all)
        end

        def find(id)
          i = fog.get(id)
          raise Mystro::Cloud::NotFound, "could not find #{id}" unless i
          decode(i)
        end

        def create(model)
          enc = encode(model)
          o = fog.create(enc)
          decode(o)
        end

        def destroy(model)
          list = fog.find(model.identity)
          list.each do |e|
            e.destroy
          end
        end

        def service
          @service ||= begin
            model = self.class.model
            s = model.constantize.new(@options)
            s
          end
        end

        def fog
          @fog ||= begin
            collection = self.class.collection
            s = service.send(collection)
            s
          end
        end

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
