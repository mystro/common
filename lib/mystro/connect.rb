module Mystro
  module Connect
    class Base
      class << self
        attr_accessor :model
        attr_accessor :collection

        def cname
          self.name.split("::").last.downcase
        end

        def fog
          Mystro.send(cname).fog || nil rescue nil
        end

        def after(event, &block)
          @hooks ||= {}
          @hooks[event] ||= []
          @hooks[event] << block
        end

        def hooks(event, *args)
          Mystro::Log.debug "#{cname}:hooks:#{event} #{@hooks[event].count}"
          @hooks[event].each do |e|
            Mystro::Log.debug "#{cname}:hooks:#{event} #{e}"
            e.call(*args) if e
          end
        end
      end

      attr_reader :cfg
      attr_reader :opt
      attr_reader :fog

      def initialize(organization)
        a = organization.data
        c = cname

        # opt is used to initialize fog in connect classes
        #defaults = a.connect!.fog? ? a.connect.fog : {}
        #overrides = a[c] && a[c].fog? ? a[c].fog : {}
        defaults = a.connect!.provider? ? a.connect.provider : {}
        overrides = a[c] && a[c].provider? ? a[c].provider : {}
        raw = defaults.deep_merge(overrides)
        if raw && raw['name']
          n = raw.delete('name')
          p = Mystro::Provider[n]
          raise "provider '#{p}' does not exist" unless p
          raw.deep_merge!(p.to_hash)
        end
        puts "RAW: #{raw.inspect}"
        @opt = Hashie::Mash.new(raw)

        # cfg is the additional configuration parms (aside from the fog block)
        raw = {}
        if a[c] && a[c]['config']
          raw = a[c]['config'].to_hash
        end
        @cfg = Hashie::Mash.new(raw)

        self.class.after :create do |e, model|
          Mystro::Plugin.run "#{cname}:create", e, model
        end

        self.class.after :destroy do |e, tags|
          Mystro::Plugin.run "#{cname}:destroy", e, tags
        end

        connect
      end

      def connect
        #puts "connect: #{model}.new(#{opt.to_hash.symbolize_keys})"
        @fog ||= model.new(opt.to_hash.symbolize_keys) if opt
      rescue => e
        Mystro::Log.error "#{cname} connect failed: #{e.message} at #{e.backtrace.first}"
      end

      def connected?
        fog.nil? ? false : true
      end

      def find(id)
        fog.send(collection).get(id)
      end

      def all
        fog.send(collection).all
      end

      def create(model)
        Mystro::Log.debug "#{cname}#create #{model.inspect}"
        Mystro::Log.debug "#{cname}#create #{fog.inspect}"
        e = fog.send(collection).create(model.fog_options)
        e
      end

      def destroy(models)
        list = [*models].flatten
        list.each do |m|
          Mystro::Log.debug "#{cname}#destroy #{m.rid}"
          e = find(m.rid)
          e.destroy if e
        end
      end

      def model
        raise "model not set for '#{cname}'" unless self.class.model
        @model ||= self.class.model.constantize
      end

      def collection
        raise "collection not set for '#{cname}'" unless self.class.collection
        @collection ||= self.class.collection
      end

      def cname
        self.class.cname
      end

      def after(*args)
        self.class.after(*args)
      end

      def hooks(*args)
        self.class.hooks(*args)
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/connect/*.rb"].each {|file| require "#{file.gsub(/\.rb/,'')}" }