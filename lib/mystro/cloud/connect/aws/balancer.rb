module Mystro
  module Cloud
    module Aws
      class Balancer < Connect
        manages 'Fog::Balancer', :load_balancers

        returns Mystro::Cloud::Balancer
        decodes :id
        decodes :dns, from: :dns_name
        decodes :computes, from: :instances, type: Array
        decodes :zones, from: :availability_zones, type: Array
        decodes :health, from: :health_check
        decodes :listeners, type: Array, of: Listener

        #decodes :image, from: :image_id
        #decodes :flavor, from: :flavor_id
        #decodes :ip, from: :public_ip_address
        #decodes :private_dns, from: :private_dns_name
        #decodes :private_ip, from: :private_ip_address
        #decodes :state
      end
    end
  end
end
