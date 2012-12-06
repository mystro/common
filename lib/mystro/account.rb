module Mystro
  class Account
    class << self
      #attr_reader :name
      attr_reader :list
      attr_reader :selected

      def read
        dir   = Mystro.directory
        @list = { }

        Dir["#{dir}/accounts/*.y*ml"].each do |file|
          name = file.gsub(/#{dir}\/accounts\//, "").gsub(/\.(\w+?)$/, "")
          Mystro::Log.debug "loading account '#{name}' '#{file}'"
          @list[name] = self.new(name, file)
        end

        @selected = default
      end

      def default
        return ENV['MYSTRO_ACCOUNT'] if ENV['MYSTRO_ACCOUNT']
        return Mystro.config.default_account if Mystro.config.default_account?
        return "default" if list.keys.include?("default")
        list.keys.first
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
      #    Mystro::Log.debug "loading account"
      #    a        = Mystro::Model::Account.load(name)
      #    a[:name] = name
      #
      #    Mystro::Log.debug "loading plugins from account"
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
      #  return ENV['RIG_ACCOUNT'] if ENV['RIG_ACCOUNT']
      #  return Mystro.config[:account] if Mystro.config[:account]
      #  return Mystro.config[:default_account] if Mystro.config[:default_account]
      #  return Mystro.config[:accounts].first if Mystro.config[:accounts] && Mystro.config[:accounts].count > 0
      #  "default"
      #end
      #
      #def save
      #  name = Mystro.account[:name]
      #  Mystro::Model::Account.save(name, Mystro.account)
      #end
    end

    attr_reader :data
    attr_reader :file
    attr_reader :name

    def initialize(name, file)
      cfg     = Mystro.config.to_hash
      account = File.exists?(file) ? YAML.load_file(file) : { }
      @name   = name
      @file   = file
      @data   = Hashie::Mash.new(cfg.deep_merge(account))
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