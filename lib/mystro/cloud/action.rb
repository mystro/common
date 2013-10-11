module Mystro
  module Cloud
    class Action
      attr_reader :action
      attr_accessor :options, :class, :data
      def initialize(klass, action)
        @class = klass
        @action = action
        @options = {}
        @data = {}
      end

      def model
        @class.split('::').last
      end

      def to_model
        @class.constantize.new(@data)
      end
    end
  end
end
