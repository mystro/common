module Mystro
  module Plugin
    class << self
      def run(event, *args)
        return if Mystro.config.mock

        @hooks ||= []
        @hooks.select { |e| e[:event] == event }.each do |plugin|
          klass = plugin[:class]
          block = plugin[:block]
          begin
            Mystro::Log.debug "calling #{klass} :: #{event}"
            block.call(args.dup)
          rescue => e
            Mystro::Log.error "failed to run event #{event} for #{klass}: #{e.message}"
            Mystro::Log.debug e
          end
        end
      end

      def on(klass, event, &block)
        @hooks ||= []
        @hooks << { :event => event, :class => klass, :block => block }
      end

      def load(plugins={ })
        plugins.each do |plugin, data|
          begin
            f = "#{Mystro.directory}/plugins/#{plugin}"
            Mystro::Log.debug "loading plugin: #{plugin} #{f}"
            require f
          rescue LoadError, StandardError => e
            Mystro::Log.error "error while loading plugin: #{plugin}: #{e.message} at #{e.backtrace.first}"
          end
        end
      end

      def register(plugin, type, klass)
        @plugins ||= {}
        @plugins[type] ||= {}
        @plugins[type][plugin] = klass
      end
    end

    module Base
      def self.included(base)
        base.extend self
      end

      def config_for(klass)
        name = klass.name.split('::').last.downcase.to_sym
        return Mystro.account.plugins[name] if Mystro.account.plugins && Mystro.account.plugins[name]
        { }
      end

      def on(event, &block)
        Mystro::Plugin.on(self, event, &block)
      end

      def command(name, desc, klass=nil, &block)
        on "commands:loaded" do |args|
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