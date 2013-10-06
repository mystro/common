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
    c = data
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
    data = {
        image: c[:image],
        flavor: c[:flavor],
        keypair: c[:keypair],
        userdata: c[:userdata],
        groups: c[:group],
        tags: {'Roles' => c[:role].join(','), 'Name' => "#{c[:name]}#{num}"},
    }
    if c[:volume]
      list = c[:volume].map do |vol|
        Mystro::Cloud::Volume.new(vol)
      end
      data[:volumes] = list
    end
    {
        model: :compute,
        action: :create,
        balancer: c[:balancer],
        records: c[:record],
        data: Mystro::Cloud::Compute.new(data)
    }
  end
end
