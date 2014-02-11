module Mystro
  module Plugin
    class << self
      def run(event, *args)
        return if Mystro.config.mock

        Mystro::Log.debug "hooks: #{event}"
        @hooks ||= []
        @hooks.select { |e| e[:event] == event }.each do |plugin|
          klass = plugin[:class]
          block = plugin[:block]
          begin
            Mystro::Log.debug "hooks: #{event}: #{klass}"
            block.call(args.dup)
          rescue => e
            Mystro::Log.error "failed hook: #{event}: #{klass}: #{e.message}"
            Mystro::Log.debug e
          end
        end
      end

      def on(klass, event, &block)
        @hooks ||= []
        @hooks << { :event => event, :class => klass, :block => block }
      end

      def load(plugins={ })
        list = plugins.reject {|k, v| k == 'disabled'}
        list.each do |plugin, data|
          load_plugin(plugin, data)
        end
      end

      def load_plugin(plugin, data)
        begin
          # load library, if it exists
          # this is for plugins in gems
          require "mystro/plugin/#{plugin}"
        rescue LoadError, StandardError => e
          Mystro::Log.debug "load plugin warning: #{plugin}: #{e.message}"
          Mystro::Log.debug e
        end

        begin
          # load file in config directory if it exists
          file = "#{Mystro.directory}/plugins/#{plugin}"
          if File.exists?("#{file}.rb")
            Mystro::Log.debug "plugin: #{plugin} = #{file}"
            require file
          end
        rescue LoadError, StandardError => e
          Mystro::Log.debug "load plugin warning: #{plugin}: #{e.message}"
          Mystro::Log.debug e
        end
      end

      def disabled?(name)
        Mystro::Log.debug "disabled? #{name}"
        Mystro.config.plugins && Mystro.config.plugins.disabled && Mystro.config.plugins.disabled[name]
      end

      def register(key, opts={})
        @plugins ||= {}
        @plugins[key] = opts
        name = key.to_s.capitalize
        @plugins[key][:name] = name
      end

      def ui
        @ui ||= begin
          ui = {}
          (@plugins||{}).each do |key, opts|
            if opts[:ui]
              n = opts[:name]
              ui[n] = opts[:ui]
            end
          end
          ui
        end
      end

      def jobs
        @jobs ||= begin
          jobs = {}
          (@plugins||{}).each do |key, opts|
            if opts[:jobs]
              jobs[key] = opts[:jobs]
            end
          end
          jobs
        end
      end

      def schedule
        @schedule ||= begin
          s = {}
          (@plugins||{}).each do |key, opts|
            if opts[:schedule]
              opts[:schedule].each do |w, o|
                n = w.to_s.capitalize + "Worker"
                s[n] = { "cron" => o}
              end
            end
          end
          s
        end
      end
    end

    module Base
      def self.included(base)
        base.extend self
      end

      def config_for(klass)
        name = klass.name.split('::').last.downcase.to_sym
        return Mystro.organization.plugins[name] if Mystro.organization.plugins && Mystro.organization.plugins[name]
        { }
      end

      def on(event, &block)
        Mystro::Plugin.on(self, event, &block)
      end

      def register(opts={})
        key = self.name.split('::').last.downcase.to_sym
        Mystro::Plugin.register(key, opts)
      end

      #def ui(path)
      #  name = self.name.split('::').last
      #  Mystro::Plugin.register_ui(name, path)
      #end

      def command(name, desc, klass=nil, &block)
        on "commands:loaded" do |args|
          Mystro::Log.debug "loading commands for #{name}"
          command = args.shift
          if klass
            command.subcommand name, "#{desc} (#{self})", klass
          else
            command.subcommand name, "#{desc} (#{self})", &block
          end
        end
      end
    end
  end
end
