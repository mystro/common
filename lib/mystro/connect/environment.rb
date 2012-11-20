module Mystro
  module Connect
    class Environment < Base
      def connect

      end

      def connected?
        true
      end

      def find(name)
        Mystro::Model::Environment.load(name)
      end

      def all
        list = Mystro.compute.all
        list.inject([]) { |a, e| a << e.tags["Environment"] }.compact.uniq.sort
      end

      def create(model)
        Mystro::Log.info "model: #{model}"
        list = model.template_to_models
      end

      def destroy

      end
    end
  end
end