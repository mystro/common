require 'spec_helper'
describe Mystro::Cloud::Aws::Record do
  def cloud
    @cloud ||= Mystro.record
  end

  def model
    @model ||= Mystro::Cloud::Record.new(
        name: "blarg.dev.ops.rgops.com",
        values: ["127.7.8.9"],
        ttl: 60,
        type: 'A'
    )
  end

  def instance
    @instance ||= begin
      cloud.create(model)
    end
  end

  before(:all) do
    cloud
    model
    instance
  end

  context "find" do
    let(:name) { 'mystro.dev.ops.rgops.com' }
    let(:instance) { cloud.find(name) }

    subject { instance }
    it { should be_instance_of(Mystro::Cloud::Record) }
    its(:name) { should == name }
  end

  context "all" do
    let(:all) { cloud.all }
    it "should return models" do
      all.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Record)
      end
    end
  end

  #if Mystro.config.test!.spend
    context "create and destroy" do
      subject { instance }

      it { should be_instance_of(Mystro::Cloud::Record) }
      its(:name) { should_not == nil }
      it "should destroy" do
        sleep 5
        expect { cloud.destroy(instance) }.not_to raise_error
      end
    end
  #end
end
