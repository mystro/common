module Mystro
  class Config
    class << self
      def instance
        @instance ||= self.new
      end
    end

    attr_reader :data

    def initialize
      f = "#{Mystro.directory}/config.yml"
      d = File.exists?(f) ? YAML.load_file(f) : {}
      c = Hashie::Mash.new(d)

      if c.logging?
        c.logging.each do |level, dest|
          Mystro::Log.add(level.to_sym, dest)
        end
      end

      Mystro::Log.debug "loading plugins from configuration"
      Mystro::Plugin.load(c[:plugins]) if c[:plugins]
      @raw = c
      @data = Hashie::Mash.new(c)
      @data.directory = Mystro.directory
    end
  end
end