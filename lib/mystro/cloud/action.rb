module Mystro
  module Cloud
    class Action
      attr_reader :action
      attr_accessor :options, :class, :data
      def initialize(action)
        @action = action
        @class = nil
        @options = {}
        @data = {}
      end

      def model
        @class.split('::').last
      end
    end
  end
end
