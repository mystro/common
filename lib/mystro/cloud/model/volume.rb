module Mystro
  module Cloud
    class Volume < Model
      attribute :name
      attribute :device, required: false
      attribute :size
      attribute :dot, required: false
      attribute :snapshot, required: false
      attribute :virtual, required: false
    end
  end
end