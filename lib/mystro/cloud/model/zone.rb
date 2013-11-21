module Mystro
  module Cloud
    class Zone < Model
      identity :id
      attribute :domain
      attribute :_raw, type: Object, required: false
    end
  end
end
