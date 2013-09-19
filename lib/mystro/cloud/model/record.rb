module Mystro
  module Cloud
    class Record < Model
      attribute :name
      attribute :values, type: Array, of: String
      attribute :ttl, type: Integer
      attribute :type
    end
  end
end
