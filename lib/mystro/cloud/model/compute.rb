module Mystro
  module Cloud
    class Compute < Model
      identity :id
      attribute :name, required: false
      attribute :image, type: String
      attribute :flavor, type: String
      attribute :region, type: String
      attribute :dns, type: String, required: false
      attribute :ip, type: String, required: false
      attribute :private_dns, type: String, required: false
      attribute :private_ip, type: String, required: false
      attribute :state, type: String
      attribute :keypair, aliases:[:key], type: String
      attribute :userdata, type: String, required: false
      attribute :groups, type: Array, of: String
      attribute :tags, type: Hash, required: false
      attribute :zone # availability zone
      has_many :volumes, type: 'Volume', required: false
      attribute :_raw, type: Object, required: false

      def name
        tags && tags['Name']
      end
    end
  end
end
