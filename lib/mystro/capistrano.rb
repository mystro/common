## integration with capistrano
## have some helpers to use mystro to get the
## host lists for capistrano to use.
#
#require 'mystro'
#require 'mystro/model'
#require 'capistrano'
#
#module Mystro
#  module Capistrano
#    def servers
#      env     = Mystro.config[:environment]
#      role    = Mystro.config[:role]
#      servers = Mystro::Model::Environment.find(env).servers
#      list    = role == 'all' ? servers : servers.select { |s| (s.tags['Roles']||"").split(",").include?(role) }
#
#      raise "Mystro could not find any servers matching environment=#{env} and role=#{role}" unless list && list.count > 0
#      list.each do |s|
#        server "#{s.tags['Name']}.#{Mystro.get_config(:dns_zone)}", :web, :app
#      end
#    rescue => e
#      puts "*** servers not found: #{e.message}"
#    end
#  end
#end
#
#::Capistrano.plugin :mystro, Mystro::Capistrano
#
#configuration = Capistrano::Configuration.respond_to?(:instance) ?
#    Capistrano::Configuration.instance(:must_exist) :
#    Capistrano.configuration(:must_exist)
#
#configuration.load do
#  puts "  * reading mystro information..."
#
#  Mystro.config[:environment] = ENV['ENVIRONMENT'] || ARGV[0]
#  Mystro.config[:role]        = ENV['ROLE'] || ARGV[1]
#
#  # create dummy tasks for environment and role
#  begin
#    ARGV.first(2).each do |arg|
#      task arg do
#        nil
#      end
#    end
#  rescue
#    nil
#  end
#
#end
