module Mystro
  module Cloud
    class Balancer < Model
      identity :id
      attribute :name
      attribute :dns
      attribute :computes, type: Array, of: String
      attribute :zones, type: Array, of: String
      attribute :health, type: Hash
      attribute :listeners, type: Array, of: Hash
      attribute :primary, type: :boolean
      attribute :_raw, type: Object, required: false
    end
  end
end
