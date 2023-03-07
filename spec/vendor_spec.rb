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

  describe '#check_stock and #stock' do
    it 'keeps track of its inventory' do
      expect(@vendor.inventory).to eq({})
      expect(@vendor.check_stock(@item1)).to eq(0)
      expect(@vendor.check_stock(@item2)).to eq(0)

      @vendor.stock(@item1, 30)

      expect(@vendor.inventory).to eq({ @item1 => 30 })
      expect(@vendor.check_stock(@item1)).to eq(30)

      @vendor.stock(@item2, 12)

      expect(@vendor.inventory).to eq({ @item1 => 30, @item2 => 12 })
      expect(@vendor.check_stock(@item2)).to eq(12)
    end

    it 'can add to an item already in stock' do
      @vendor.stock(@item1, 30)
      @vendor.stock(@item1, 25)

      expect(@vendor.inventory).to eq({ @item1 => 55 })
      expect(@vendor.check_stock(@item1)).to eq(55)
    end
  end
end
