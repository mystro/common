module Mystro
  module DSL
    class Health < Mystro::DSL::Base
      attribute :target, value: "HTTP:80/"
      attribute :interval, value: 30
      attribute :timer, value: 5
      attribute :healthy, value: 2
      attribute :unhealthy, value: 10
    end
  end
end
