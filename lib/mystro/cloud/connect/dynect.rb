require 'mystro/cloud/connect/fog'
module Mystro
  module Cloud
    module Dynect
      class Connect < Mystro::Cloud::Fog::Connect
        #def all
        #  service.get_zone
        #end
        #
        #def find(id)
        #  raise "not implemented"
        #end
        #
        #def create(model)
        #  raise "not implemented"
        #end
        #
        #def destroy(model)
        #  raise "not implemented"
        #end
        #
        #def service
        #  @service ||= begin
        #    # dynect4r
        #    #  ::Dynect::Client.new(
        #    #      :customer_name => @options[:dynect_customer],
        #    #      :user_name => @options[:dynect_username],
        #    #      :password => @options[:dynect_password],
        #    #  )
        #    ::DynectRest.new(
        #        @options[:dynect_customer],
        #        @options[:dynect_username],
        #        @options[:dynect_password],
        #        @config[:zone], true)
        #  end
        #end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/dynect/*rb"].each do |file|
  #puts "dynect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
