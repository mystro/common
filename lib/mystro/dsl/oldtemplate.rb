#module Mystro
#  module DSL
#    module Template
#      class << self
#        def load(name_or_file)
#          @templates    ||= {}
#          template_name = nil
#          template_file = nil
#          if File.exists?(name_or_file)
#            template_name = File.basename(name_or_file).gsub(/\.rb$/, "").to_sym
#            template_file = name_or_file
#          elsif File.exists?("#{dir}/#{name_or_file}.rb")
#            template_name = name.to_sym
#            template_file = "#{dir}/#{name}.rb"
#          end
#          raise "could not load template #{template_name} (#{template_file})" unless template_file && File.file?(template_file)
#          #raise "template already loaded #{template_name}" if @templates[template_name]
#          @templates[template_name] ||= begin
#            t = Mystro::DSL::Template::DSL.new(template_name)
#            t.instance_eval(File.read(template_file), "Template(#{template_file})")
#            @templates[template_name] = t
#          end
#        end
#
#        def load_yaml_file(path)
#          file = File.expand_path(path)
#          raise "Configuration not found: #{path} (#{file})" unless File.exists?(file)
#          yaml = YAML.load_file(file)
#          yaml = yaml[yaml.keys.first] if yaml.keys.count == 1
#
#          yaml
#        end
#
#        def list
#          Dir["#{dir}/*"].inject({}) do |h, e|
#            f           = e.gsub("#{dir}/", "")
#            f           = File.basename(f, ".yml")
#            h[f.to_sym] = e
#            h
#          end
#        end
#
#        private
#        def dir
#          "#{Mystro.directory}/templates"
#        end
#      end
#
#      class DSL
#        attr_reader :balancers, :servers
#
#        def initialize(name)
#          @name      = name.to_sym
#          @balancers = []
#          @servers   = []
#        end
#
#        def template(&block)
#          instance_eval &block
#        end
#
#        def balancer(name, &block)
#          balancer = Balancer.new(name)
#          balancer.instance_eval &block
#          @balancers << balancer
#        end
#
#        def server(name, &block)
#          server = Server.new(name)
#          server.instance_eval &block
#          @servers << server
#        end
#      end
#
#      class Base
#        def attr(name, value=nil)
#          @attrs[name] = value unless value.nil?
#          @attrs[name]
#        end
#
#        def list_attr(name, value=nil)
#          @attrs[name] ||= []
#          unless value.nil?
#            if value.kind_of?(Array)
#              @attrs[name] += value
#            else
#              @attrs[name] << value
#            end
#          end
#          @attrs[name]
#        end
#      end
#
#      class Server < Base
#        def initialize(name)
#          @attrs = {
#              :name     => name.to_sym,
#              :roles    => [],
#              :groups   => [],
#              :count    => 1,
#              :image    => nil,
#              :flavor   => nil,
#              :keypair  => nil,
#              :userdata => "default",
#              :dnsnames => [],
#          }
#        end
#
#        def name
#          @attrs[:name]
#        end
#
#        def roles
#          @attrs[:roles]
#        end
#
#        def groups
#          @attrs[:groups]
#        end
#
#        def dnsnames
#          @attrs[:dnsnames]
#        end
#
#        def role(r)
#          list_attr(:roles, r)
#        end
#
#        def count(c=nil)
#          attr(:count, c)
#        end
#
#        def image(i=nil)
#          attr(:image, i)
#        end
#
#        def flavor(f=nil)
#          attr(:flavor, f)
#        end
#
#        def group(g)
#          list_attr(:groups, g)
#        end
#
#        def keypair(k=nil)
#          attr(:keypair, k)
#        end
#
#        def userdata(u=nil)
#          attr(:userdata, u)
#        end
#
#        def balancer(b=nil, &block)
#          if block_given?
#            raise "balancer block must specify name" unless b
#            Mystro::DSL::Template::DSL.balancer(b, &block)
#          end
#          attr(:balancer, b)
#        end
#
#        def dns(name)
#          n = name.gsub(Mystro.get_config(:dns_zone), "")
#          list_attr(:dnsnames, n)
#        end
#      end
#
#      class Balancer
#        attr_reader :name, :sticky, :primary, :sticky_type, :sticky_arg
#
#        def initialize(name)
#          @listeners = []
#          @name      = name.to_sym
#          @primary   = false
#          @sticky    = false
#        end
#
#        def primary(enable = nil)
#          enable.nil? ? @primary : @primary = enable
#        end
#
#        def listener(&block)
#          listener = Listener.new
#          listener.instance_eval &block
#          @listeners << listener
#        end
#
#        def health(&block)
#          healthcheck = HealthCheck.new
#          healthcheck.instance_eval &block
#          @healthcheck = healthcheck
#        end
#
#        def listeners
#          @listeners.map { |e| e.spec }
#        end
#
#        def sticky(type=nil, expires_or_cookie=nil)
#          if type && expires_or_cookie
#            @sticky      = true
#            @sticky_type = type
#            @sticky_arg  = expires_or_cookie
#          end
#          @sticky
#        end
#      end
#
#      class Listener
#        def initialize
#          @from_proto = nil
#          @from_port  = nil
#          @to_proto   = nil
#          @to_port    = nil
#          @cert       = nil
#        end
#
#        def from(proto, port)
#          @from_proto = proto
#          @from_port  = port
#        end
#
#        def to(proto, port)
#          @to_proto = proto
#          @to_port  = port
#        end
#
#        def cert(cert)
#          @cert = cert
#        end
#
#        def spec
#          {
#              :from => "#@from_proto:#@from_port",
#              :to   => "#@to_proto:#@to_port",
#              :cert => @cert,
#          }
#        end
#      end
#
#      class HealthCheck
#        def initialize
#          @healthy   = 10
#          @unhealthy = 2
#          @interval  = 30
#          @target    = nil
#          @timeout   = 5
#        end
#
#        def healthy(v)
#          @healthy = v
#        end
#
#        def unhealthy(v)
#          @unhealthy = v
#        end
#
#        def interval(v)
#          @interval = v
#        end
#
#        def target(v)
#          @target = v
#        end
#
#        def timeout(v)
#          @timeout = v
#        end
#
#        def spec
#          raise "target not specified for health check" unless @target
#          {
#              healthy: @healthy,
#              unhealthy: @unhealthy,
#              interval: @interval,
#              target: @target,
#              timeout: @timeout,
#          }
#        end
#      end
#    end
#  end
#end
