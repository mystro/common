class Mystro::Dsl::Balancer < Mystro::Dsl::Base
  attribute :name
  attribute :primary, type: :boolean, value: false
  has_one :health
  has_many :listeners

  def actions
    hash = data
    b = Mystro::Cloud::Balancer.new({
          health: hash[:health],
          listeners: hash[:listener],
        })
    [{
        model: :balancer,
        action: :create,
        data: b
    }]
  end
end
