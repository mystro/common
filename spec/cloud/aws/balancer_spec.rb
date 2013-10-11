require 'spec_helper'
describe Mystro::Cloud::Aws::Balancer, :aws do
  def cloud
    @cloud ||= connect('aws', 'balancer')
  end
  def config
    @config ||= load_config('aws', 'balancer')
  end
  it_behaves_like 'cloud balancer'
end
