require 'spec_helper'

RSpec.describe Vendor do
  before(:each) do
    @item1 = Item.new({ name: 'Peach',
                        price: '$0.75' })
    @item2 = Item.new({ name: 'Tomato',
                        price: '$0.50' })
    @vendor = Vendor.new('Rocky Mountain Fresh')
  end

  describe '#initialize' do
    it 'exists and has attributes' do
      expect(@vendor).to be_a Vendor
      expect(@vendor.name).to eq('Rocky Mountain Fresh')
    end
  end
end
