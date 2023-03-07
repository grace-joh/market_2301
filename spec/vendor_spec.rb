require 'spec_helper'

RSpec.describe Vendor do
  before(:each) do
    @item1 = Item.new({ name: 'Peach',
                        price: '$0.75' })
    @item2 = Item.new({ name: 'Tomato',
                        price: '$0.50' })
    @item3 = Item.new({ name: 'Peach-Raspberry Nice Cream',
                        price: '$5.30' })
    @item4 = Item.new({ name: 'Banana Nice Cream',
                        price: '$4.25' })
    @vendor = Vendor.new('Rocky Mountain Fresh')
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor2.stock(@item3, 25)
    @vendor2.stock(@item4, 50)
    @vendor3 = Vendor.new('Palisade Peach Shack')
    @vendor3.stock(@item1, 65)
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

  describe '#potential_revenue' do
    it 'can calculate its revenue if all of its stock was sold' do
      @vendor.stock(@item1, 35)
      @vendor.stock(@item2, 7)

      expect(@vendor.potential_revenue).to eq(29.75)
      expect(@vendor2.potential_revenue).to eq(345.00)
      expect(@vendor3.potential_revenue).to eq(48.75)
    end
  end
end
