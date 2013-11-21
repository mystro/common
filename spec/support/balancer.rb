require 'spec_helper'
shared_examples "cloud balancer" do
  def cloud
    @cloud ||= Mystro.balancer
  end

  def model
    @model ||= begin
      l = Mystro::Cloud::Listener.new(config[:listener])
      Mystro::Cloud::Balancer.new(config[:model].merge(listeners: [l]))
    end
  end

  before(:all) do
    cloud
    model
  end

  context "find" do
    let(:id) { config[:id] }
    let(:exists) { cloud.find(id) }

    subject { exists }
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
      subject { cloud.create(model) }

      it { should be_instance_of(Mystro::Cloud::Balancer) }
      its(:id) { should_not == nil }
      it "should destroy" do
        sleep 5
        expect { cloud.destroy(instance) }.not_to raise_error
      end
    end
  end
end
