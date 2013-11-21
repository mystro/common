require 'mystro/cloud/connect/fog'
module Mystro
  module Cloud
    module Aws
      class Connect < Mystro::Cloud::Fog::Connect
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/aws/*rb"].each do |file|
  #puts "aws: #{file}"
  require "#{file.gsub(/\.rb/, '')}"
end
