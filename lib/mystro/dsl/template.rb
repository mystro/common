module Mystro
  module DSL
    class Template < Base
      has_many :balancers, named: true
      has_many :computes, named: true
    end
  end
end
