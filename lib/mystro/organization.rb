require 'mystro/cloud'

module Mystro
  class Organization
    class << self
      attr_reader :selected

      def [](name)
        get(name)
      end

      def get(name)
        @list[name]
      end

      def read
        dir = Mystro.directory
        @list = {}

        Dir["#{dir}/organizations/*.y*ml"].each do |file|
          name = file.gsub(/#{dir}\/organizations\//, "").gsub(/\.(\w+?)$/, "")
          Mystro::Log.debug "loading organization '#{name}' '#{file}'"
          @list[name] = self.new(name, file)
        end

        @selected = default
        puts "selected:#{@selected}"

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
    end

    attr_reader :data
    attr_reader :file
    attr_reader :name

    def initialize(name, file)
      cfg = Mystro.config.to_hash
      organization = File.exists?(file) ? YAML.load_file(file) : {}
      @name = name
      @file = file
      @data = Hashie::Mash.new(cfg.deep_merge(organization))
      @data.name = name
    end

    def to_hash
      @data.to_hash
    end

    def compute
      @compute ||= connect(:compute)
    end

    def balancer
      #@balancer ||= Mystro::Connect::Balancer.new(self) if @data.balancer
      @balancer ||= connect(:balancer)
    end

    def record
      #@dns ||= Mystro::Connect::Dns.new(self) if @data.dns
      @dns ||= connect(:record)
    end

    #def environment
    #  @environment ||= Mystro::Connect::Environment.new(self)
    #end

    protected

    def connect(type)
      raise "#{type} not configured: see mystro/config.yml or mystro/organization/*.yml" unless @data[type]
      raise "#{type} provider not configured" unless @data[type].provider!.name
      options = @data[type].provider.to_hash.symbolize_keys
      config = @data[type].config.to_hash.symbolize_keys if @data[type].config
      pn = options.delete(:name)
      raise "provider not set" unless pn
      Mystro::Cloud.new(pn, type, {options: options, config: config})
    end
  end
end
