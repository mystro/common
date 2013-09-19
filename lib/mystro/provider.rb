module Mystro
  class Provider
    class << self
      def [](name)
        get(name)
      end

      def get(name)
        @list ||= {}
        @list[name]
      end

      def read
        dir   = Mystro.directory
        @list ||= { }

        Dir["#{dir}/providers/*.y*ml"].each do |file|
          name = file.gsub(/#{dir}\/providers\//, "").gsub(/\.(\w+?)$/, "")
          Mystro::Log.debug "loading provider '#{name}' '#{file}'"
          @list[name] = self.new(name, file)
        end
      end
    end

    attr_reader :data
    attr_reader :file
    attr_reader :name

    def initialize(name, file)
      yaml = File.exists?(file) ? YAML.load_file(file) : { }
      @name   = name
      @file   = file
      @data   = Hashie::Mash.new(yaml)
    end

    #def to_hash
    #  dup = @data.dup
    #  dup.delete(:name)
    #  dup
    #end
    def to_hash
      @data.to_hash.symbolize_keys
    end
  end
end
