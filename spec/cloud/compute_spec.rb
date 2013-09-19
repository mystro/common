require 'spec_helper'
describe Mystro::Cloud::Aws::Compute do
  def cloud
    @cloud ||= Mystro.compute
  end

  def model
    @model ||= Mystro::Cloud::Compute.new(
        image: 'ami-0145d268',
        flavor: 'm1.small',
        keypair: 'mystro',
        groups: ['default'],
        tags: {'Name' => "compute_spec_testing", 'Environment' => 'rspec', 'Organization' => 'test'}
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
    let(:id) { 'i-69d32404' }
    let(:instance) { cloud.find(id) }

    subject { instance }
    it { should be_instance_of(Mystro::Cloud::Compute) }
    its(:id) { should == id }
  end

  context "missing" do
    it "should throw an error" do
      expect { cloud.find('i-00000000') }.to raise_error(Mystro::Cloud::NotFound)
    end
  end

  context "all" do
    let(:all) { cloud.all }
    it "should return models" do
      all.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Compute)
      end
    end
  end

  context "running" do
    let(:running) { cloud.running }
    it "should return models" do
      running.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Compute)
      end
    end
    it "should be running" do
      running.each do |i|
        expect(i.state).to eq('running')
      end
    end
  end

  if Mystro.config.test!.spend
    context "create and destroy" do
      subject { instance }

      it { should be_instance_of(Mystro::Cloud::Compute) }
      its(:id) { should_not == nil }
      its(:image) { should == model.image }
      its(:flavor) { should == model.flavor }
      it "should destroy" do
        expect { cloud.destroy(instance) }.not_to raise_error
      end
    end
  end
end
