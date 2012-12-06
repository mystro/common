module Mystro
  module Connect
    class Compute < Base
      self.model      = "Fog::Compute"
      self.collection = :servers

      def all(filters={ })
        fog.send(collection).all(filters)
      end

      def running
        all({ "instance-state-name" => "running" })
      end

      def find(id_or_name)
        if id_or_name =~ /^i-/
          super(id_or_name)
        else
          find_by_name(id_or_name)
        end
      end

      def find_by_name(name)
        list = find_by_tags(name: name)
        return list if list.count > 0
        find_by_nick(name)
      end

      def find_by_nick(nick)
        Mystro::Log.debug "compute#find_by_nick #{nick}"
        (name, env) = nick.match(/(\w+)\.(\w+)/)[1..2]
        find_by_environment(env).select { |s| s.tags['Name'] =~ /^#{name}/ }
      rescue => e
        Mystro::Log.error "error finding server by nickname #{nick}. name should be of the form: role#.environment"
        []
      end

      def find_by_environment(environment)
        find_by_tags(environment: environment)
      end

      def find_by_environment_and_role(environment, role)
        list = find_by_tags(environment: environment)
        list.select { |s| r = s.tags['Roles'] || s.tags['Role']; r.split(",").include?(role) }
      end

      def find_by_tags(tags)
        Mystro::Log.debug "compute#find_by_tags #{tags.inspect}"
        filters = tags.inject({ }) { |h, e| (k, v) = e; h["tag:#{k.to_s.capitalize}"] = v; h }
        all(filters)
      end

      def create(model)
        Mystro::Log.debug "#{cname}#create #{model.inspect}"
        e = fog.send(collection).create(model.fog_options)
        fog.create_tags(e.id, model.fog_tags)
        Mystro::Plugin.run "compute:create", e, model
        e
      end

      #after :create do |compute, model|
      #  Mystro::Log.debug "compute#after_create #{compute.id} #{model.fog_tags}"
      #  Mystro::Log.debug "#{cname}#create #{fog.inspect}"
      #  sleep 3
      #end

      def destroy(models)
        list = [*models].flatten
        list.each do |m|
          Mystro::Log.debug "#{cname}#destroy #{m.rid}"
          e = find(m.rid)
          Mystro::Plugin.run "compute:destroy", e, m
          e.destroy
          tags = e.tags.keys.inject({ }) { |h, e| h[e] = nil; h }
          fog.create_tags([e.id], tags)
        end
      end

      #def destroy(list)
      #  list = [*list]
      #  if list.count > 0
      #    ids = list.map {|e| e.kind_of?(String) ? e : e.id}
      #    Mystro::Log.debug "compute#destroy: #{ids.inspect}"
      #    list.each do |e|
      #      Mystro::Plugin.run "compute:destroy", e
      #      e.destroy
      #      tags = e.tags.keys.inject({}) {|h, e| h[e] = nil; h }
      #      fog.create_tags(ids, tags)
      #    end
      #  end
      #end

      #after :destroy do |compute, tags|
      #  Mystro::Log.debug "#{cname}#after_destroy"
      #  tags = compute.tags.keys.inject({ }) { |h, e| h[e] = nil; h }
      #  fog.create_tags([compute.id], tags) if tags.count > 0
      #end
    end
  end
end