class Mystro::Dsl::Compute < Mystro::Dsl::Base
  attribute :num, value: 0 do |value|
    value == value.to_i
  end
  attribute :name
  attribute :image
  attribute :flavor
  attribute :keypair
  attribute :userdata
  attribute :group, type: Array
  attribute :role, type: Array
  has_many :volumes
  has_many :records
  references :balancer

  def actions
    c = to_hash
    n = c[:num].to_i
    out = []
    if n > 0
      1.upto(n) do |i|
        out << create_action(i, c)
      end
    else
      out << create_action(nil, c)
    end
    out
  end

  private

  def create_action(i, c)
    num = i ? "%02d" % i : ''
    name = "#{c[:name]}#{num}"
    roles = (c[:role]||[]).join(',')
    action = Mystro::Cloud::Action.new('Mystro::Cloud::Compute', :create)
    action.options = {
        balancer: c[:balancer],
        records: c[:record],
    }
    data = {
        image: c[:image],
        flavor: c[:flavor],
        keypair: c[:keypair],
        userdata: c[:userdata],
        groups: c[:group],
        tags: {'Roles' => roles, 'Name' => name},
    }.delete_if {|k, v| v.nil?}
    if c[:volume]
      data[:volumes] = c[:volume].map do |vol|
        Mystro::Cloud::Volume.new(vol)
      end
    end
    action.data = data
    action
  end
end
