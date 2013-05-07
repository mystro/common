module Mystro
  module DSL
    class Balancer < Base
      attribute :primary, type: :boolean, value: false
      has_one :sticky
      has_one :health
      has_many :listeners
    end
  end
end
