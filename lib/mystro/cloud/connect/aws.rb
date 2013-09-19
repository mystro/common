require 'fog'
require 'mystro/ext/fog/balancer'

module Mystro
  module Cloud
    module Aws
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
          fog.destroy(model.id)
        end

        def service
          @service ||= begin
            model = self.class.model
            s = model.constantize.new(@options.merge(:provider => 'AWS'))
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

        def encode(model)
          raise "encode: model is nil" unless model
          model.is_a?(Array) ? model.map {|e| _encode(e)} : _encode(model)
        end

        def decode(object)
          raise "decode: object is nil" unless object
          object.is_a?(Array) ? object.map {|e| _decode(e)} : _decode(object)
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

Dir["#{File.dirname(__FILE__)}/aws/*rb"].each do |file|
  #puts "connect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
