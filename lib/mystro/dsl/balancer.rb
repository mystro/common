class Mystro::Dsl::Balancer < Mystro::Dsl::Base
  attribute :name
  attribute :primary, type: :boolean, value: false
  has_one :health
  has_many :listeners

  def actions
    hash = to_hash
    action = Mystro::Cloud::Action.new('Mystro::Cloud::Balancer', :create)
    action.data = {
        name: hash[:name],
        primary: hash[:primary],
        health: hash[:health],
        listeners: hash[:listener],
    }
    [action]
  end
end
