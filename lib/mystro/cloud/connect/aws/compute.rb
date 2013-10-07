require 'simple_uuid'

module Mystro
  module Cloud
    module Aws
      class Compute < Connect
        manages 'Fog::Compute', :servers

        def all(filters={})
          decode(service.send(collection).all(filters))
        end

        def running
          all({ "instance-state-name" => "running" })
        end

        def create(model)
          e = encode(model)
          r = service.send(collection).create(e)
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
          #Mystro::Log.debug "decode: #{server.inspect}"
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
          model.zone = server.availability_zone
          model._raw = server
          #Mystro::Log.debug "decode: #{model.inspect}"
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
          #if model.volumes
          #  image = service.images.get(model.image)
          #  map = image.block_device_mapping.inject({}) {|h, e| h[e['deviceName']] = e; h}
          #  devices = map.keys
          #  last = devices.last
          #  root = image.root_device_name
          #  model.volumes.each do |volume|
          #    dev = volume.device || volume.name
          #    dev = root if dev == :root || dev == 'root'
          #    unless map[dev]
          #      Mystro::Log.error "something wrong, trying to change volume: #{volume.inspect}"
          #      next
          #    end
          #    if volume.device == :next
          #      last = last.next
          #      o = {'deviceName' => last, 'volumeSize' => volume.size, 'deleteOnTermination' => volume.dot}
          #      o.merge({'snapshotId' => volume.snapshot}) if volume.snapshot
          #      o.merge({'virtualName' => volume.virtual}) if volume.virtual
          #      map[last] = o
          #    else
          #      map[dev]['volumeSize'] = volume.size if volume.size
          #      map[dev]['snapshotId'] = volume.snapshot if volume.snapshot
          #      map[dev]['deleteOnTermination'] = volume.dot if volume.dot
          #    end
          #  end
          #  bdm = map.inject([]) {|a, e| a << e.last}
          #  options['blockDeviceMapping'] = bdm
          #end
          Mystro::Log.debug "encode: #{options.inspect}"
          options
        end
      end
    end
  end
end
