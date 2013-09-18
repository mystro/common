module Mystro
  module Cloud
    class Connect
      attr_reader :options

      def initialize(options)
        @options = options
        @lookup = {}
        @fog = nil
        @service = nil
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
        return model.map { |e| encode(e) } if obj.is_a?(Array)
        from_model(model)
      end

      def decode(obj)
        return obj.map { |e| decode(e) } if obj.is_a?(Array)
        out = to_model(obj)
        out.validate!
        out
      end

      protected

      def instance
        c = self.class.klass
        c.is_a?(String) ? c.constantize.new : c.new
      end

      #def from_model(model)
      #  {
      #      image_id: model.image,
      #      flavor_id: model.flavor,
      #      key_name: model.keypair,
      #      groups: model.groups,
      #      region: model.region,
      #      user_data: model.userdata
      #  }
      #end

      def from_model(model)
        out = {}
        self.class.decoders.each do |d|
          name = d[:name].to_sym
          from = d[:from] ? d[:from].to_sym : name
          raw = inc.send(from) rescue :no_method
          list = raw.respond_to?(:each) ? raw : [raw].flatten
          list.each do |e|
            out[from] = e
          end
        end
        out
      end

      def to_model(inc)
        out = instance
        return instance unless inc
        #puts "incoming: #{inc.inspect}"
        self.class.decoders.each do |d|
          #puts "D:#{d.inspect}"
          name = d[:name].to_sym
          from = d[:from] ? d[:from].to_sym : name
          raw = inc.send(from) rescue :no_method
          list = raw.respond_to?(:each) ? raw : [raw].flatten

          values = list.map do |e|
            #puts "each: #{e}"
            v = :unknown
            if d[:block]
              v = instance_exec(inc, &d[:block])
            elsif d[:map]
              v = d[:map].call(e)
            elsif d[:lookup]
              c = lookup(d[:lookup])
              v = c.find(e)
            else
              v = e
            end
            v
          end

          #puts "values: #{values.inspect}"
          if d[:type] == Array
            out.send("#{name}=", values)
          else
            out.send("#{name}=", values.first)
          end
        end

        #puts "outgoing: #{out.inspect}"
        out
      end

      #def lookup(name)
      #  @lookup[name] ||= begin
      #    c = self.class.name
      #    a = c.split('::')
      #    a.pop
      #    a << name.to_s.capitalize
      #    a.join('::').constantize.new(options)
      #  end
      #end

      class << self
        attr_reader :model, :collection, :klass, :decoders

        protected

        def manages(fog_model, fog_collection)
          @model = fog_model
          @collection = fog_collection
        end

        def returns(klass)
          @klass = klass
        end

        def decodes(name, options={}, &block)
          @decoders ||= []
          d = {name: name}.merge(options)
          d = d.merge(block: block) if block_given?
          @decoders << d
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/connect/**/*rb"].each do |file|
  #puts "connect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
