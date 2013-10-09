require 'spec_helper'
shared_examples "cloud record" do
  def model
    @model ||= Mystro::Cloud::Record.new(config[:model])
  end

  before(:all) do
    cloud
    model
  end

  context "find", :find do
    let(:id) { config[:id] }
    let(:name) { config[:name] }
    let(:model) { cloud.find(id) }

    subject { model }
    it { should be_instance_of(Mystro::Cloud::Record) }
    its(:id) { should == id }
    its(:name) { should == name }
  end

  #context "all" do
  #  let(:all) { cloud.all }
  #  it "should return models" do
  #    all.each do |i|
  #      expect(i).to be_instance_of(Mystro::Cloud::Record)
  #    end
  #  end
  #end
  #
  ##if Mystro.config.test!.spend
  #  context "create and destroy" do
  #    #subject { instance }
  #    #
  #    #it { should be_instance_of(Mystro::Cloud::Record) }
  #    #its(:name) { should_not == nil }
  #
  #    it "should create and destroy" do
  #      n = cloud.create(model)
  #      expect(n).to be_instance_of(Mystro::Cloud::Record)
  #      expect(n.name).not_to be(nil)
  #
  #      o = cloud.find_by_name(config[:model][:name])
  #      expect { cloud.destroy(o) }.not_to raise_error
  #
  #      expect{cloud.find_by_name(config[:model][:name])}.to raise_error
  #    end
  #  end
  ##end
end
