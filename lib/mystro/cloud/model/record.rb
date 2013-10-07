require 'ipaddress'

module Mystro
  module Cloud
    class Record < Model
      identity :id
      attribute :name
      attribute :values, type: Array, of: String
      attribute :ttl, type: Integer
      attribute :type
      attribute :_raw, type: Object, required: false

      # TODO: not sure why this doesn't work, keeps returning 'A'
      #def type
      #  puts "TYPE: #{@data[:type]} ip?=#{::IPAddress.valid?(values.first)}"
      #  @data[:type] || ::IPAddress.valid?(values.first) ? 'A' : 'CNAME'
      #end
    end
  end
end
