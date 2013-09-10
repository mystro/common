module Mystro
  class Organization
    class << self
      #attr_reader :name
      #attr_reader :list
      attr_reader :selected

      def [](name)
        get(name)
      end

      def get(name)
        @list[name]
      end

      def read
        dir   = Mystro.directory
        @list = { }

        Dir["#{dir}/organizations/*.y*ml"].each do |file|
          name = file.gsub(/#{dir}\/organizations\//, "").gsub(/\.(\w+?)$/, "")
          Mystro::Log.debug "loading organization '#{name}' '#{file}'"
          @list[name] = self.new(name, file)
        end

        @selected = default
      end

      def default
        return ENV['MYSTRO_ORGANIZATION'] if ENV['MYSTRO_ORGANIZATION']
        return Mystro.config.default_organization if Mystro.config.default_organization?
        return "default" if @list.keys.include?("default")
        @list.keys.first
      end

      def select(name)
        @selected = name
      end

      #def data(name = get)
      #  if @name != name
      #    @data = nil
      #    @loaded = false
      #    @name = nil
      #  end
      #
      #  @data ||= begin
      #    Mystro::Log.debug "loading organization"
      #    a        = Mystro::Model::Organization.load(name)
      #    a[:name] = name
      #
      #    Mystro::Log.debug "loading plugins from organization"
      #    Mystro::Plugin.load(a[:plugins]) if a[:plugins]
      #
      #    a
      #  end
      #  @name = @data[:name]
      #  @loaded = true
      #  @data
      #end
      #
      #def get
      #  return ENV['RIG_ORGANIZATION'] if ENV['RIG_ORGANIZATION']
      #  return Mystro.config[:organization] if Mystro.config[:organization]
      #  return Mystro.config[:default_organization] if Mystro.config[:default_organization]
      #  return Mystro.config[:organizations].first if Mystro.config[:organizations] && Mystro.config[:organizations].count > 0
      #  "default"
      #end
      #
      #def save
      #  name = Mystro.organization[:name]
      #  Mystro::Model::Organization.save(name, Mystro.organization)
      #end
    end

    attr_reader :data
    attr_reader :file
    attr_reader :name

    def initialize(name, file)
      cfg     = Mystro.config.to_hash
      organization = File.exists?(file) ? YAML.load_file(file) : { }
      @name   = name
      @file   = file
      @data   = Hashie::Mash.new(cfg.deep_merge(organization))
      @data.name = name
    end

    def compute
      @compute ||= Mystro::Connect::Compute.new(self) if @data.compute
    end

    def balancer
      @balancer ||= Mystro::Connect::Balancer.new(self) if @data.balancer
    end

    def dns
      @dns ||= Mystro::Connect::Dns.new(self) if @data.dns
    end

    def environment
      @environment ||= Mystro::Connect::Environment.new(self)
    end
  end
end
