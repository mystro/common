require 'spec_helper'
shared_examples "cloud compute" do
  def model
    @model ||= Mystro::Cloud::Compute.new(config[:model])
  end

  before(:all) do
    cloud
    model
  end

  context "find" do
    let(:id) { config[:id] }
    let(:exists) { cloud.find(id) }

    subject { exists }
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

  context 'volumes' do
    def vmodel
      @vmodel ||= Mystro::Cloud::Compute.new(config[:vmodel])
    end

    it "should create" do
      expect { cloud.create(vmodel) }.not_to raise_error
    end
  end

  #context "create and destroy" do
  #  instance = cloud.create(model)
  #
  #  it "should destroy" do
  #    expect(instance).to be_instance_of(Mystro::Cloud::Compute)
  #    expect(instance.id).not_to be(nil)
  #    expect(instance.image).to eq(model[:image])
  #    expect(instance.flavor).to eq(model[:flavor])
  #    expect { cloud.destroy(instance) }.not_to raise_error
  #  end
  #end
end
