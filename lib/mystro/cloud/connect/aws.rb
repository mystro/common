require 'fog'

module Mystro
  module Cloud
    module Aws
      class Connect < Mystro::Cloud::Connect
        attr_reader :options

        def initialize(options)
          @options = options
          @service = nil
          @fog = nil
        end

        def all
          decode(fog.all)
        end

        def find(id)
          decode(fog.get(id))
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
          return model.map { |e| encode(e) } if model.is_a?(Array)
          out = {}
          self.class.decoders.each do |d|
            name = d[:name].to_sym
            from = d[:from] ? d[:from].to_sym : name
            out[from] = model.send(name)
          end
          out.delete_if { |k, v| v.nil? }
        end

        def decode(inc)
          return inc.map { |e| decode(e) } if inc.is_a?(Array)

          out = instance
          return out unless inc
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
                v = case d[:block].arity
                      when 1
                        instance_exec(e, &d[:block])
                      when 2
                        instance_exec(out, e, &d[:block])
                      else
                        instance_exec(out, inc, e, &d[:block])
                    end
              elsif d[:map]
                v = d[:map].call(e)
                #elsif d[:lookup]
                #  c = lookup(d[:lookup])
                #  v = c.find(e)
              else
                v = e
              end
              v
            end

            if d[:type] == Array
              #puts "values: #{values.inspect}"
              out.send("#{name}=", values)
            else
              #puts "values: #{values.first.inspect}"
              out.send("#{name}=", values.first)
            end
          end

          #puts "outgoing: #{out.inspect}"
          out.validate!
          out
        end

        protected

        def instance
          c = self.class.klass
          c.is_a?(String) ? c.constantize.new : c.new
        end

        def lookup(name)
          @lookup[name] ||= begin
            c = self.class.name
            a = c.split('::')
            a.pop
            a << name.to_s.capitalize
            a.join('::').constantize.new(options)
          end
        end

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
end

Dir["#{File.dirname(__FILE__)}/aws/*rb"].each do |file|
  #puts "connect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end