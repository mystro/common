module Mystro
  module DSL
      class Listener < Mystro::DSL::Base
        attribute :from, value: "http:80"
        attribute :to, value: "http:80"
        attribute :cert
      end
  end
end
