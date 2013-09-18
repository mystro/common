
module Mystro
  module Cloud
    class << self
      def new(options)
        provider = options.delete(:provider)
        type = options.delete(:type)
        klass = class_for(provider, type)
        klass.new(options)
      end

      def class_for(provider, type)
        n = provider.to_s.capitalize
        t = type.to_s.capitalize
        c = "Mystro::Cloud::#{n}::#{t}"
        c.constantize
      end
    end
  end
end

require 'mystro/cloud/model'
require 'mystro/cloud/connect'
