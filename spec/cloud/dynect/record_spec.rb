require 'spec_helper'
describe Mystro::Cloud::Dynect::Record, :dynect do
  def cloud
    @cloud ||= connect('dynect', 'record')
  end
  def config
    @config ||= load_config('dynect', 'record')
  end
  it_behaves_like 'cloud record'
end
