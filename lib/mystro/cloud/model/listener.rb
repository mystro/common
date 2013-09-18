module Mystro
  module Cloud
    class Listener < Model
      attribute :to_protocol
      attribute :to_port, type: Integer
      attribute :port, type: Integer
      attribute :protocol
      attribute :policy, type: Array, required: false
      attribute :cert, required: false

      def from
        "#{protocol}:#{port}"
      end
      def to
        "#{to_protocol}:#{to_port}"
      end

      def to_hash
        {
            to: to,
            from: from,
            policy: policy,
            cert: cert,
        }.delete_if {|k, v| v.nil?}
      end
    end
  end
end
