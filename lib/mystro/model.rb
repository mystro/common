require 'mystro-common'

module Mystro
  module Model
    class Base
      attr_reader :attributes

      def initialize(attributes={ })
        # all the stringify keys calls are to make sure that we normalize EVERYTHING before merges
        d = defaults.stringify_keys!
        c = load_from_config.stringify_keys!
        a = attributes.stringify_keys!
        # attributes should ALWAYS be stringified keys
        @attributes = d.deep_merge(c).deep_merge(a).stringify_keys!
      end

      def defaults
        self.class.defaults || {}
      end

      def fog_tags(hash=self.class.tagnames.each {|t| hash[t] = send(t) })
        hash.inject({ }) do |h, e|
          (k, v)                    = e
          h["#{k.to_s.capitalize}"] = v
          h
        end
      end

      private

      def load_from_config
        cname    = self.class.name.split("::").last.downcase
        config = { }
        if Mystro.organization && Mystro.organization[cname]
          config = Mystro.organization[cname].to_hash
        end
        config["organization"] = Mystro.selected
        config
      end

      class << self
        attr_reader :tagnames
        attr_reader :attrnames
        attr_reader :defaults

        def attr(*list)
          @attrnames = list
          list.each do |a|
            define_method(a) do
              @attributes[a.to_s]
            end
            define_method("#{a}=") do |val|
              @attributes[a.to_s] = val
            end
          end
        end

        def tag(*list)
          @tagnames = list
          attr(*list)
        end

        def default(hash)
          @defaults = hash
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/model/*.rb"].each { |file| require file.gsub(/\.rb/, '') }
