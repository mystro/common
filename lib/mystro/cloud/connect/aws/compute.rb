module Mystro
  module Cloud
    module Aws
      class Compute < Connect
        manages 'Fog::Compute', :servers

        def all(filters={})
          decode(service.send(collection).all(filters))
        end

        def running
          all({"instance-state-name" => "running"})
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
          #TODO: disable volumes until we can figure out fix for fog
          map = mapping(model)
          options[:block_device_mapping] = map if map
          Mystro::Log.debug "encode: #{options.inspect}"
          options
        end

        def mapping(model)
          return unless model.volumes

          image = service.images.get(model.image)
          map = map_transform(image.block_device_mapping)
          devices = map.keys
          last = devices.last
          root = image.root_device_name
          Mystro::Log.debug "ROOT: #{root.inspect}"
          model.volumes.each do |volume|
            Mystro::Log.debug "VOLUME: #{volume.inspect}"
            dev = volume.device || volume.name
            if dev == :root || dev == 'root'
              if image.root_device_type != "ebs"
                Mystro::Log.error "trying to change ephemeral root volume"
                raise "trying to change ephemeral root volume"
              end
              dev = root
              unless map[dev]
                Mystro::Log.error "something wrong, trying to change root volume: #{volume.inspect}"
                return
              end
            end
            if volume.device == :next
              last = last.next
              map[last] = {
                  'deviceName' => last,
                  'volumeSize' => volume.size,
                  'deleteOnTermination' => volume.dot,
                  'snapshotId' => volume.snapshot,
                  'virtualName' => volume.virtual,
              }
            elsif !map[dev]
              map[dev] = {
                  'deviceName' => dev,
                  'volumeSize' => volume.size,
                  'deleteOnTermination' => volume.dot,
                  'snapshotId' => volume.snapshot,
                  'virtualName' => volume.virtual,
              }
            else
              map[dev]['volumeSize'] = volume.size.to_s if volume.size
              map[dev]['snapshotId'] = volume.snapshot if volume.snapshot
              map[dev]['deleteOnTermination'] = volume.dot if volume.dot
            end
            Mystro::Log.debug "VOLUME: => (#{dev}) #{map[dev].inspect}"
          end
          change_keys(map_untransform(map))
        end

        def change_keys(map)
          name_mapping = {
              'deviceName' => 'DeviceName',
              'virtualName' => 'VirtualName',
              'snapshotId' => 'Ebs.SnapshotId',
              'volumeSize' => 'Ebs.VolumeSize',
              'deleteOnTermination' => 'Ebs.DeleteOnTermination',
          }
          map.map do |volume|
            out = {}
            name_mapping.each do |key, value|
              out[value] = volume[key].to_s if volume[key]
            end
            out
          end
        end

        def map_transform(map)
          map.inject({}) { |h, e| h[e['deviceName']] = e; h }
        end

        def map_untransform(map)
          map.inject([]) { |a, e| a << e.last }
        end
      end
    end
  end
end
