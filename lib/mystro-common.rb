require "mystro/common/version"
require "fog"
require "mystro/ext/fog/balancer"
require "hashie/mash"
require "active_support/all"

module Mystro
  class << self
    def config
      Mystro::Config.instance.data
    end

    def account
      current_account.data
    end

    def current_account
      Mystro::Account.list[selected]
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
      Mystro::Account.selected
    end

    def compute
      current_account.compute
    end

    def dns
      current_account.dns
    end

    def balancer
      current_account.balancer
    end

    def environment
      current_account.environment
    end
  end
end

require "mystro/config"
require "mystro/account"
require "mystro/log"
require "mystro/dsl/template"
require "mystro/plugin"
require "mystro/connect"

Mystro::Account.read
Mystro::Log.init