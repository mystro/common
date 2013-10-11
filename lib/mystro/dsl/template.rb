class Mystro::Dsl::Template < Mystro::Dsl::Base
  has_many :computes, named: true
  has_many :balancers, named: true

  def actions
    out = []
    @data[:compute] && @data[:compute].each do |c|
      out += c.actions
    end
    @data[:balancer] && @data[:balancer].each do |b|
      out += b.actions
    end
    out
  end
end
