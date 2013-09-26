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
