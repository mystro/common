module Mystro
  module Cloud
    module Aws
      class Compute < Connect
        manages 'Fog::Compute', :servers

        def all(filters={})
          decode(fog.all(filters))
        end

        def running
          all({ "instance-state-name" => "running" })
        end

        def create(model)
          e = encode(model)
          r = fog.create(e)
          model.id = r.id
          tag(model)
          model
        end

        def tag(model)
          unless model.id
            Mystro::Log.warn "tag called with no id"
            return
          end
          t = model.tags
          service.create_tags(model.id, t)
        end

        def untag
          raise "write me"
        end

        protected

        def _decode(server)
          Mystro::Log.debug "decode: #{server.inspect}"
          model = Mystro::Cloud::Compute.new
          model.id = server.id
          model.image = server.image_id
          model.flavor = server.flavor_id
          model.dns = server.dns_name
          model.ip = server.public_ip_address
          model.private_dns = server.private_dns_name
          model.private_ip = server.private_ip_address
          model.state = server.state
          model.region = service.region
          model.keypair = server.key_name
          model.groups = server.groups #.map {|e| e.name}
          model.tags = server.tags #.inject({}){|h, e| h[e.first] = e.last; h} if server.tags
          model.userdata = server.user_data
          Mystro::Log.debug "decode: #{model.inspect}"
          model
        end

        def _encode(model)
          Mystro::Log.debug "encode: #{model.inspect}"
          options = {
              image_id: model.image,
              flavor_id: model.flavor,
              key_name: model.keypair,
              groups: model.groups,
              region: model.region,
              user_data: model.userdata,
          }
          Mystro::Log.debug "encode: #{options.inspect}"
          options
        end
      end
    end
  end
end
