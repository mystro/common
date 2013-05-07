require "active_support/all"

module Mystro
  module DSL
    class Base
      attr_reader :data

      def initialize
        @data = Marshal.load(Marshal.dump(self.class.attrs))
      end

      def method_missing(method, *args, &block)
        m = method.to_sym
        raise "unknown attribute #{method}: #{@data.inspect}" unless @data[m]
        o = @data[m]

        if o[:type] == :array
          #puts "setting #{m} << #{args.first}"
          o[:value] << args.first
        elsif o[:type] == :child
          #puts "setting child #{m} << #{o[:klass]}"
          k = o[:klass].constantize
          obj = k.new
          obj.instance_eval &block
          if o[:many]
            if o[:named]
              o[:value] ||= {}
              o[:value][args.first.to_sym] = obj.to_hash
            else
              o[:value] << obj.to_hash
            end
          else
            raise "setting more than one #{method}: previous: #{o[:value].inspect}" if o[:value]
            o[:value] = obj.to_hash
          end
        else
          #puts "setting #{m} = #{args.first}"
          o[:value] = args.first
        end
      end

      def validate!
        if @data[:block]
          block.call(self)
        end
      rescue => e
        raise "validation failed: #{e.message} at #{e.backtrace.first}"
      end

      def to_hash
        @hash ||= begin
          validate!
          out = {}
          @data.each do |k, v|
            out[k] = v[:value]
          end
          out
        end
      end

      #def to_mash
      #  Hashie::Mash.new(to_hash)
      #end

      class << self
        @attrs = {}
        attr_accessor :attrs

        def attribute(name, options={}, &block)
          n = name.to_sym
          o = {
              value: nil,
              type: :string,
              klass: nil
          }.merge(options)
          #puts "ATTR: #{name} - #{o.inspect}"

          if o[:type] == :array
            n = name.to_s.singularize.to_sym
            o[:value] = [] unless o[:value]
          else
            if o[:type] == :child
              if o[:many]
                if o[:named]
                  o[:value] = {} unless o[:value]
                else
                  o[:value] = [] unless o[:value]
                end
              else
                o[:value] = nil
              end
            end

          end

          o[:block] = block if block_given?

          @attrs ||= {}
          @attrs[n] = o
        end

        def has_one(name, options={})
          o = {
              klass: find_class(name),
              type: :child,
              many: false,
              named: false,
              value: nil
          }.merge(options)
          attribute(name, o)
        end

        def has_many(names, options={})
          singular = names.to_s.singularize
          o = {
              klass: find_class(singular),
              type: :child,
              many: true,
              named: false,
              value: nil
          }.merge(options)
          attribute(singular, o)
        end

        def references(name, options={})
          attribute(name, options)
        end

        def find_class(name)
          c = "Mystro::DSL::#{name.capitalize}"
          #puts "FINDCLASS: #{name} #{c}"
          c
        rescue => e
          raise "could not find class: #{c}: #{e.message} at #{e.backtrace.first}"
        end
      end
    end
  end
end

dir = "#{File.dirname(__FILE__)}/dsl"
Dir[File.join("#{dir}/**", "*.rb")].each do |file|
  #puts "loading: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
