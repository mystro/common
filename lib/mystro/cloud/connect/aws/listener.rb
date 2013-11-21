module Mystro
  module Cloud
    module Aws
      class Listener < Connect

        protected

        def _decode(listener)
          model = Mystro::Cloud::Listener.new
          model.to_port = listener.instance_port
          model.to_protocol = listener.instance_protocol
          model.port = listener.lb_port
          model.protocol = listener.protocol
          model.cert = listener.ssl_id
          model.policy = listener.policy_names
          model._raw = listener
          model
        end

        def _encode(model)
          {
              'Listener'    => {
                  "Protocol" => model.protocol,
                  "LoadBalancerPort" => model.port,
                  "InstanceProtocol" => model.to_protocol,
                  "InstancePort" => model.to_port,
                  "SSLCertificateId" => model.cert,
                  "PolicyNames" => []
              },
              'PolicyNames' => []
          }
        end
      end
    end
  end
end
