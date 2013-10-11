require 'damsel/data'

module Mystro
  module Dsl
    class Base < Damsel::Data

    end

    class << self
      def get(name)
        n = name.to_sym
        raise "no template named #{name}" unless @templates[n]
        @templates[n]
      end

      def load(file)
        @templates ||= {}
        file = File.expand_path(file)
        name = File.basename(file).gsub(/\.rb$/, "").to_sym
        raise "file: '#{file}' does not exist" unless File.exist?(file)
        @templates[name] ||= begin
          t = Mystro::Dsl::TemplateFile.new(file)
          t.instance_eval(File.read(file), "#{file}:[TemplateFile]")
          t
        end
      end

      def actions(name)
        tf = get(name)
        t = tf[:template]
        t.actions
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/dsl/*rb"].each do |file|
  #puts "dsl: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
