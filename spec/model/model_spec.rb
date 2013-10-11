require 'spec_helper'

class Mystro::Cloud::TestModel < Mystro::Cloud::Model
  identity :id
  attribute :name, aliases: [:alias]
  attribute :string, type: String
  attribute :int, type: Integer
  attribute :notrequired, required: false
  attribute :items, type: Array
  attribute :numbers, type: Array
  #has_many :records, type: 'Record'
end

describe Mystro::Cloud::TestModel do
  let(:id) { "id" }
  let(:model) {
    Mystro::Cloud::TestModel.new(
        id: id,
        name: 'name',
        string: "string",
        int: 5,
        items: ["one", "two", "three"],
        numbers: [0, 1, 2],
        #records: [Mystro::Cloud::Record.new(name:"blarg.blarg.com")]
    )
  }
  context "identity" do
    subject { model }
    its(:identity) { should == id }
    its(:id) { should == id }
  end
  context "validity" do
    context "string" do
      subject { model }
      it "should be valid with string" do
        expect { model.validate! }.not_to raise_error
      end
      it "should not be valid without string" do
        model.string = nil
        expect { model.validate! }.to raise_error
      end
    end
    context "integer" do
      subject { model }
      it "should be valid with int" do
        expect { model.validate! }.not_to raise_error
      end
      it "should not be valid without int" do
        model.int = nil
        expect { model.validate! }.to raise_error
      end
    end
    context "not required" do
      subject { model }
      it "should be valid with or without notrequired" do
        expect { model.validate! }.not_to raise_error
        model.notrequired = 'blarg'
        expect { model.validate! }.not_to raise_error
      end
    end
    context "array" do
      context "string" do
        subject {model}
        it "should not be valid without items" do
          model.items = nil
          expect { model.validate! }.to raise_error
        end
        it "should not be valid without numbers" do
          model.numbers = nil
          expect { model.validate! }.to raise_error
        end
      end
    end
    #context "has_many" do
    #  subject {model}
    #  it "should be valid with records" do
    #    expect { model.validate! }.not_to raise_error
    #  end
    #  it "should not be valid without records" do
    #    model.records = nil
    #    expect { model.validate! }.to raise_error
    #  end
    #  it "should not be valid without records being records" do
    #    model.records = [0]
    #    expect { model.validate! }.to raise_error
    #  end
    #end
  end
end
