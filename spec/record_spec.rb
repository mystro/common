require 'mystro-common'

describe Mystro::Cloud::Aws::Balancer do
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
    @instance ||= cloud.create(model)
  end

  before(:all) do
    cloud
    model
    instance
  end

  context "find" do
    let(:id) { 'mystro.dev.ops.rgops.com' }
    let(:instance) { cloud.find(id) }

    subject { instance }
    it { should be_instance_of(Mystro::Cloud::Record) }
    its(:id) { should == id }
  end

  context "all" do
    let(:all) { cloud.all }
    it "should return models" do
      all.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Record)
      end
    end
  end

  if Mystro.config.test!.spend
    context "create and destroy" do
      subject { instance }

      it { should be_instance_of(Mystro::Cloud::Balancer) }
      its(:id) { should_not == nil }
      it "should destroy" do
        sleep 5
        expect { cloud.destroy(instance) }.not_to raise_error
      end
    end
  end
end
