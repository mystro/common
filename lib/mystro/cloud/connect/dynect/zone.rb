module Mystro
  module Cloud
    module Dynect
      class Zone < Connect
        manages 'Fog::DNS', :zones

        protected

        def _decode(object)
          Mystro::Log.debug "decode: #{object.inspect}"
          model = Mystro::Cloud::Zone.new
          model.id = object.id
          model.domain = object.domain
          model._raw = object
          Mystro::Log.debug "decode: #{model.inspect}"
          model
        end

        def _encode(model)
          Mystro::Log.debug "encode: #{model.inspect}"
          options = {
              #image_id: model.image,
              #flavor_id: model.flavor,
              #key_name: model.keypair,
              #groups: model.groups,
              #region: model.region,
              #user_data: model.userdata,
          }
          Mystro::Log.debug "encode: #{options.inspect}"
          options
        end
      end
    end
  end
end
