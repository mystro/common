require 'mystro/cloud/connect/aws'

module Mystro
  module Cloud
    module Aws
      class Compute < Mystro::Cloud::Aws::Connect
        manages 'Fog::Compute', :servers

        def all(filters={})
          decode(fog.all(filters))
        end

        def running
          all({ "instance-state-name" => "running" })
        end

        returns Mystro::Cloud::Compute
        decodes :id
        decodes :image, from: :image_id
        decodes :flavor, from: :flavor_id
        decodes :dns, from: :dns_name
        decodes :ip, from: :public_ip_address
        decodes :private_dns, from: :private_dns_name
        decodes :private_ip, from: :private_ip_address
        decodes :state
        decodes :region do
          service.region
        end
        decodes :keypair, from: :key_name
        decodes :groups, type: Array #, map: Proc.new {|e| e.name}
        decodes :tags do |out, tags|
          o = out.tags || {}
          o[tags.first] = tags.last if tags
          o
        end
        decodes :userdata, from: :user_data
      end
    end
  end
end
