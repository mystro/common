require 'mystro/ext/dynect_rest/resource'
class DynectRest
  def any
    DynectRest::AnyResource.new(self, @zone)
  end
end
