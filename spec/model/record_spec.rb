require 'spec_helper'
describe Mystro::Cloud::Record do
  let(:name) { "blarg.dev.ops.rgops.com" }
  let(:values) { ["127.7.8.9"] }
  let(:ttl) { 60 }
  let(:type) { 'A' }
  let(:model) {
    Mystro::Cloud::Record.new(
        id: name,
        name: name,
        values: values,
        ttl: ttl,
        type: type
    )
  }

  subject { model }
  it { should be_instance_of(Mystro::Cloud::Record) }
  its(:identity) { should == name }
  its(:name) { should == name }
  its(:values) { should == values }
  its(:type) { should == type }
  its(:ttl) { should == ttl }
  it "should be valid" do
    expect { model.validate! }.not_to raise_error
  end
end
