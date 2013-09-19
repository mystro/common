require 'spec_helper'
shared_examples "cloud balancer" do
  def cloud
    @cloud ||= Mystro.balancer
  end

  def model
    @model ||= Mystro::Cloud::Balancer.new(
        id: 'BALANCER-SPEC',
        listeners: [
            Mystro::Cloud::Listener.new(
                protocol: 'HTTP',
                port: 80,
                to_protocol: 'HTTP',
                to_port: 80,
                cert: nil
            )
        ]
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
    let(:id) { 'RG-EVENTS-1' }
    let(:instance) { cloud.find(id) }

    subject { instance }
    it { should be_instance_of(Mystro::Cloud::Balancer) }
    its(:id) { should == id }
  end

  context "all" do
    let(:all) { cloud.all }
    it "should return models" do
      all.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Balancer)
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
