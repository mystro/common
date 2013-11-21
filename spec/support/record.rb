require 'spec_helper'
shared_examples "cloud record" do
  def model
    @model ||= Mystro::Cloud::Record.new(config[:model])
  end

  before(:all) do
    cloud
    model
  end

  context 'find', :find do
    context 'by id' do
      let(:id) { config[:id] }
      let(:name) { config[:name] }
      let(:found) { cloud.find(id) }

      subject { found }
      it { should be_instance_of(Mystro::Cloud::Record) }
      its(:id) { should == id }
      its(:name) { should == name }
    end

    context 'by name' do
      let(:id) { config[:id] }
      let(:name) { config[:name] }
      let(:found) { cloud.find_by_name(name) }

      subject { found }
      it { should be_instance_of(Mystro::Cloud::Record) }
      its(:id) { should == id }
      its(:name) { should == name }
    end

    context 'doesnt exist' do
      let(:id) { '123456789'}
      it 'should handle missing' do
        expect { cloud.find(id) }.to raise_error(Mystro::Cloud::NotFound)
        #expect(found).to be(nil)
      end
    end
  end

  context 'all', :all do
    let(:all) { cloud.all }
    it 'should return models' do
      all.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Record)
      end
    end
  end

  context 'create and destroy', :cad do
    it 'should create and destroy' do
      n = cloud.create(model)
      expect(n).to be_instance_of(Mystro::Cloud::Record)
      expect(n.name).not_to be(nil)

      o = cloud.find_by_name(config[:model][:name])
      expect { cloud.destroy(o) }.not_to raise_error

      expect { cloud.find_by_name(config[:model][:name]) }.to raise_error
    end
  end
end
