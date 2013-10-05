require 'mystro/log'

module Mystro
  module Cloud
    class Model
      attr_reader :data

      def initialize(hash={})
        @data = {}
        load(hash)
      end

      def load(hash)
        #puts "LOAD: #{hash.inspect}"
        if hash.is_a?(Hash)
          hash.each do |k, v|
            k = normal_key(k)
            k = alias_for(k) || k
            attr = attribute_for(k)
            #puts "attr: #{k}: #{attr.inspect}"
            raise "attr not found for #{k.inspect}" unless attr
            if attr[:child]
              if attr[:type] == Array
                next unless v# && v.count
                v = [v] unless v.is_a?(Array)
                @data[k] ||= []
                v.each do |e|
                  c = class_for(attr[:of])
                  @data[k] << c.new(e)
                end
              else
                c = class_for(attr[:type])
                if v.class == c
                  @data[k] = v
                else
                  @data[k] = c.new(v)
                end
              end
            else
              @data[k] = v
            end
          end
        else
          hash
        end
      end

      def validate!
        self.class.validate!(@data)
      end

      def attribute_for(name)
        self.class.attribute_for(name)
      end

      def alias_for(name)
        self.class.alias_for(name)
      end

      def normal_key(k)
        self.class.normal_key(k)
      end

      def class_for(name)
        self.class.class_for(name)
      end

      def [](key)
        send(key.to_sym)
      end
      def []=(key, value)
        send("#{key}=", value)
      end

      def to_hash
        out = {}
        #puts "#{self.class.name}: to_hash:"
        @data.each do |k, v|
          #puts "  #{k} => #{v}"
          if v.respond_to?(:to_hash)
            out[k] = v.to_hash
          elsif v.is_a?(Array)
            out[k] = v.map {|e| e.respond_to?(:to_hash) ? e.to_hash : e}
          else
            out[k] = v
          end
        end
        out
      end

      class << self

        def validate!(data)
          @attributes.each do |k, v|
            type = v[:type]
            type = type.is_a?(String) ? class_for(type) : type
            value = data[k]
            value = value.to_s if value.is_a?(Symbol)
            #puts "checking: #{k}#{'*' if v[:required]} (#{type})"
            raise "#{k} required but is nil or false" if v[:required] && !value
            raise "#{k} required but empty" if v[:required] && type == Array && value.empty?
            raise "incorrect type: #{k}: '#{value.inspect}' is not a '#{type}'" if value && !value.is_a?(type)
          end
        rescue => e
          raise "#{e.message}: #{data.inspect}"
        end

        def attribute_for(name)
          @attributes[name] || @attributes[name] || @aliases[name] && @attributes[@aliases[name]]
        end

        def alias_for(name)
          @aliases[name]
        end

        def class_for(name)
          n = name.to_s.capitalize
          begin
            return "Mystro::Cloud::#{n}".constantize
          rescue => e
            begin
              return n.constantize
            rescue => e
              raise "couldn't find class: #{n}: #{e.message}"
            end
          end
        end

        def normal_key(k)
          k.to_s.downcase.to_sym
        end

        protected

        def identity(name, options={})
          attribute(name, options.merge(identity: true))
        end

        def attribute(name, options={})
          @attributes ||= {}
          @aliases ||= {}
          name = normal_key(name)
          o = {name: name, type: String, required: true, aliases: []}.merge(options)
          @attributes[name.to_sym] = o
          list = [name] + o[:aliases]
          list += [:identity] if o[:identity]
          list.each do |m|
            define_method(m) do
              @data[name.to_sym]
            end
            define_method("#{m}=") do |value|
              h = {}
              h[name.to_sym] = value
              load(h)
            end
          end
          o[:aliases].each do |a|
            @aliases[normal_key(a)] = name
          end
        end

        def has_one(name, options={})
          attribute(name, {type: options.delete(:type), child: true}.merge(options))
        end

        def has_many(name, options={})
          attribute(name, {type: Array, of: options.delete(:type), child: true}.merge(options))
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/model/*.rb"].each do |file|
  #puts "require: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
