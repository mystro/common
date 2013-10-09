require 'ext/fog/dynect/dns'
require 'ext/fog/dynect/models/dns/records'
require 'ext/fog/dynect/requests/dns/get_all_records'
require 'mystro/cloud/connect/fog'

module Mystro
  module Cloud
    module Dynect
      class Connect < Mystro::Cloud::Fog::Connect

      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/dynect/*rb"].each do |file|
  #puts "dynect: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
