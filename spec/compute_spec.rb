require 'mystro-common'

describe Mystro::Cloud::Aws::Compute do
  before(:all) do
    @cxn = Mystro::Cloud.new(
        provider: :aws,
        type: :compute,
        aws_access_key_id: 'AKIAIVMUCDVWWZFFLVGA',
        aws_secret_access_key: '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')
  end

  it "should find an instance" do
    i = @cxn.find('i-69d32404')
    expect(i).to be_instance_of(Mystro::Cloud::Compute)
    expect(i.id).to eq('i-69d32404')
  end

  it "should create and destroy an instance" do
    model = Mystro::Cloud::Compute.new(
        image: 'ami-0145d268',
        flavor: 'm1.small',
        keypair: 'mystro',
        groups: ['default']
    )
    @instance = @cxn.create(model)
    sleep 5
    @cxn.destroy(@instance)
  end

  context "should load a collection of instances" do
    it "should be valid" do
      list = @cxn.all
      expect(list.count).not_to eq(0)
      list.each do |i|
        expect(i).to be_instance_of(Mystro::Cloud::Compute)
      end
    end

    it "should filter" do
      list = @cxn.running
      expect(list.count).not_to eq(0)
      list.each do |i|
        expect(i.state).to eq('running')
      end
    end
  end
end