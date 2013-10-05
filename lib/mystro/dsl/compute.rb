class Mystro::Dsl::Compute < Mystro::Dsl::Base
  attribute :num, value: 0
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

  def to_cloud
    c = to_hash
    n = c[:num].to_i
    out = []
    if n > 0
      1.upto(n) do |i|
        out << to_cloud_data(i, c)
      end
    else
      out << to_cloud_data(nil, c)
    end
    out
  end
  def to_cloud_data(i, c)
    num = i ? "%02d" % i : ''
    {
        model: :compute,
        action: :create,
        balancer: c[:balancer],
        records: c[:record],
        data: Mystro::Cloud::Compute.new({
                                             image: c[:image],
                                             flavor: c[:flavor],
                                             keypair: c[:keypair],
                                             userdata: c[:userdata],
                                             groups: c[:group],
                                             volumes: c[:volume].map{|e| Mystro::Cloud::Volume.new(e)},
                                             tags: {'Roles' => c[:role].join(','), 'Name' => "#{c[:name]}#{num}"},
                                         })
    }
  end
end