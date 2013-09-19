module Mystro
  module Cloud
    class Balancer < Model
      identity :id
      attribute :dns
      attribute :computes, type: Array, of: String
      attribute :zones, type: Array, of: String
      attribute :health, type: Hash
      attribute :listeners, type: Array, of: Hash

    end
  end
end
