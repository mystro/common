module Mystro
  module Cloud
    class Connect
      attr_reader :options

      def initialize(options, config)
        @options = options
        @config = config
      end

      def all
        raise "not implemented"
      end

      def find(id)
        raise "not implemented"
      end

      def create(model)
        raise "not implemented"
      end

      def destroy(model)
        raise "not implemented"
      end

      def encode(model)
        raise "encode: model is nil" unless model
        model.is_a?(Array) ? model.map {|e| _encode(e)} : _encode(model)
      end

      def decode(object)
        raise "decode: object is nil" unless object
        object.is_a?(Array) ? object.map {|e| _decode(e)} : _decode(object)
      end

      protected

      def _encode(model)
        raise "not implemented"
      end

      def _decode(object)
        raise "not implemented"
      end

      class << self
        attr_reader :model, :collection, :klass, :decoders

        protected

        def manages(fog_model, fog_collection)
          @model = fog_model
          @collection = fog_collection
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/connect/*rb"].each do |file|
  #puts "connect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
