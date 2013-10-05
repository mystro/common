class Mystro::Dsl::Template < Mystro::Dsl::Base
  has_many :computes, named: true
  has_many :balancers, named: true

  def to_cloud
    out = []
    @data[:compute] && @data[:compute][:value] && @data[:compute][:value].each do |k, c|
      out += c.to_cloud
    end
    @data[:balancer] && @data[:balancer][:value] && @data[:balancer][:value].each do |k, b|
      out << b.to_cloud
    end
    out
  end
end