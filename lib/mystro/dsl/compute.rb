module Mystro
  module DSL
    class Compute < Base
      attribute :primary, type: :boolean, value: false
      attribute :num, value: 1
      attribute :image
      attribute :flavor
      attribute :keypair
      attribute :userdata, value: "default"

      attribute :roles, type: :array
      attribute :groups, type: :array

      references :balancer
    end
  end
end
