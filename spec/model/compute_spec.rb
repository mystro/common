require 'spec_helper'
describe Mystro::Cloud::Compute do
  let(:id) { 'i-00000000'}
  let(:image) { 'ami-0145d268' }
  let(:flavor) { 'm1.small' }
  let(:keypair) { 'mystro' }
  let(:groups) { ['default'] }
  let(:tags) { {'Name' => "compute_spec_testing", 'Environment' => 'rspec', 'Organization' => 'test'} }
  let(:model) {
    Mystro::Cloud::Compute.new(
      id: id,
      image: image,
      flavor: flavor,
      keypair: keypair,
      groups: groups,
      tags: tags,
      region: 'us-east-1',
      state: :running
    )
  }

  subject { model }
  it { should be_instance_of(Mystro::Cloud::Compute) }
  its(:identity) { should == id }
  its(:id) { should == id }
  its(:image) { should == image }
  its(:flavor) { should == flavor }
  its(:groups) { should == groups }
  its(:keypair) { should == keypair }
  its(:key) { should == keypair }
  its(:name) { should == "compute_spec_testing"}
  it "should be valid" do
    expect { model.validate! }.not_to raise_error
  end
end
