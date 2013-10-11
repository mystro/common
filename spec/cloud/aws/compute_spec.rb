require 'spec_helper'
describe Mystro::Cloud::Aws::Compute, :aws do
  def cloud
    @cloud ||= connect('aws', 'compute')
  end
  def config
    @config ||= load_config('aws', 'compute')
  end
  it_behaves_like 'cloud compute'
end
