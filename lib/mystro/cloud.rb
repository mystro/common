
module Mystro
  module Cloud
    class << self
      def new(provider, type, options={})
        d = {
            options: {},
            config: {},
        }.merge(options)
        o = d[:options].merge(Mystro::Provider.get(provider).to_hash)
        c = d[:config]
        klass = class_for(provider, type)
        klass.new(o, c)
      end
      #def new(options)
      #  provider = options.delete(:provider)
      #  type = options.delete(:type)
      #  klass = class_for(provider, type)
      #  klass.new(options)
      #end

      def class_for(provider, type)
        n = provider.to_s.capitalize
        t = type.to_s.capitalize
        c = "Mystro::Cloud::#{n}::#{t}"
        c.constantize
      end
    end
    class NotFound < StandardError; end
  end
end

require 'mystro/cloud/model'
require 'mystro/cloud/connect'
