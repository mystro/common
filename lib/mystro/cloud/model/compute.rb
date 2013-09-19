module Mystro
  module Cloud
    class Compute < Model
      identity :id
      attribute :image, type: String
      attribute :flavor, type: String
      attribute :region, type: String
      attribute :dns, type: String, required: false
      attribute :ip, type: String, required: false
      attribute :private_dns, type: String, required: false
      attribute :private_ip, type: String, required: false
      attribute :state, type: String
      attribute :keypair, aliases:[:key], type: String #, type: "Key"
      attribute :userdata, type: String, required: false
      attribute :groups, type: Array, of: String
      attribute :tags, type: Hash, required: false

      def name
        tags && tags['Name']
      end
    end
  end
end
