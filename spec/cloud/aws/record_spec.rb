require 'spec_helper'
describe Mystro::Cloud::Aws::Record, :aws do
  def cloud
    @cloud ||= connect('aws', 'record')
  end
  def config
    @config ||= load_config('aws', 'record')
  end
  it_behaves_like 'cloud record'
end
