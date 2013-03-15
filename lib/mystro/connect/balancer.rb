
module Mystro
  module Connect
    class Balancer < Base
      self.model      = "Fog::Balancer"
      self.collection = :load_balancers

      def all
        fog.send(collection).all
      end

      def create(model)
        balancer = fog.send(collection).create(model.fog_options)
        balancer.register_instances(model.computes.collect{|e| e.rid})
        balancer.save
      end

      def find_by_environment(name)
        all.select {|e| e.id =~ /^#{name}\-/}
      end

      def listener_find(id, from)
        balancer = find(id)
        (from_proto, from_port) = from.split(':')
        match = balancer.listeners.select {|l| l.protocol == from_proto && l.lb_port == from_port.to_i }
        raise "no listeners #{from} found" if match.count == 0
        raise "more than one listener matched #{from}" if match.count > 1
        match.first
      end

      def listener_create(id, model)
        Mystro::Log.debug "balancer#add_listener #{id} #{model.inspect}"
        lb = find(id)
        opts = model.fog_options
        ap opts
        lb.listeners.create(opts)
      end

      def listener_destroy(id, from)
        Mystro::Log.debug "balancer#rm_listener #{id} #{from}"
        listener = listener_find(id, from)
        listener.destroy
      end

      def health_check(id, health)
        Mystro::Log.debug "balancer#health_check #{id} #{health.inspect}"
        balancer = find(id)
        raise "balancer #{id} not found" unless balancer

        fog.configure_health_check(id, health.fog_options)
      end

      def sticky(id, type, expires_or_cookie, port, policy=nil)
        balancer = find(id)
        raise "balancer #{id} not found" unless balancer

        policy ||= "sticky-#{id}-#{type}-#{port}"
        policies = balancer.attributes["ListenerDescriptions"] ? balancer.attributes["ListenerDescriptions"].inject([]) {|a, e| a << e["PolicyNames"]}.flatten : []
        policies << policy

        case type.downcase.to_sym
          when :app, :application
            fog.create_app_cookie_stickiness_policy(id, policy, expires_or_cookie)
            fog.set_load_balancer_policies_of_listener(id, port.to_i, policies)
          when :lb, :loadbalancer, :load_balancer
            fog.create_lb_cookie_stickiness_policy(id, policy, expires_or_cookie.to_i)
            fog.set_load_balancer_policies_of_listener(id, port.to_i, policies)
          else
            raise "unknown sticky type #{type}"
        end
      end

      def unsticky(id, type, port, policy=nil)
        balancer = find(id)
        raise "balancer #{id} not found" unless balancer

        policy ||= "sticky-#{id}-#{type}-#{port}"
        policies = balancer.attributes["ListenerDescriptions"] ? balancer.attributes["ListenerDescriptions"].inject([]) {|a, e| a << e["PolicyNames"]}.flatten : []
        policies.delete(policy)

        case type.downcase.to_sym
          when :app, :application, :lb, :loadbalancer, :load_balancer
            fog.set_load_balancer_policies_of_listener(id, port.to_i, policies)
            fog.delete_load_balancer_policy(id, policy)
          else
            raise "unknown sticky type #{type}"
        end
      end
    end
  end
end