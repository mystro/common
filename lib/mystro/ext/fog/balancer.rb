# make load balancers act more like other models in Fog
# ultimately a hack, but makes things work for now.
module Fog
  class Balancer
    def self.new(attributes)
      attributes = attributes.dup
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
        when :aws
          Fog::AWS::ELB.new(attributes)
        else
          raise ArgumentError.new("#{provider} is not a recognized balancer provider")
      end
    end
  end
end