module Mystro
  module Cloud
    module Aws
      class Listener < Connect

        returns Mystro::Cloud::Listener
        decodes :to_port, from: :instance_port
        decodes :to_protocol, from: :instance_protocol
        decodes :port, from: :lb_port
        decodes :protocol
        decodes :cert, from: :ssl_id
        decodes :policy, from: :policy_names
      end
    end
  end
end
