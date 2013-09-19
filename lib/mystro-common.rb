require "mystro/common/version"
#require "fog"
#require "mystro/ext/fog/balancer"
require "hashie/mash"
require "active_support/all"

module Mystro
  class << self
    def config
      Mystro::Config.instance.data
    end

    def organization
      raise "mystro organization unset! default organization ('#{config.default_organization}') doesn't exist?" unless current_organization
      current_organization.data
    end

    def current_organization
      Mystro::Organization.get(selected)
    end

    def directory
      @dir ||= begin
        d = "~/.mystro"
        if ENV["MYSTRO_CONFIG"]
          d = ENV["MYSTRO_CONFIG"]
        elsif File.exists?("./config/mystro")
          d = "./config/mystro"
        elsif File.exists?("./.mystro")
          d = "./.mystro"
        end
        File.expand_path(d)
      end
    end

    def selected
      Mystro::Organization.selected
    end

    def compute
      current_organization.compute
    end

    def record
      current_organization.record
    end

    def balancer
      current_organization.balancer
    end

    def environment
      current_organization.environment
    end
  end
end

require "mystro/config"
require 'mystro/cloud'
require "mystro/log"
require "mystro/provider"
require "mystro/organization"
require "mystro/dsl/template"
require "mystro/plugin"
require "mystro/connect"
require "mystro/userdata"

Mystro::Config.instance
Mystro::Provider.read
Mystro::Organization.read
