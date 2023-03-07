require 'spec_helper'

RSpec.describe Vendor do
  before(:all) do
    @item1 = Item.new({ name: 'Peach',
                        price: '$0.75' })
    @item2 = Item.new({ name: 'Tomato',
                        price: '$0.50' })
    @vendor1 = Vendor.new('Rocky Mountain Fresh')
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @item3 = Item.new({ name: 'Peach-Raspberry Nice Cream',
                        price: '$5.30' })
    @item4 = Item.new({ name: 'Banana Nice Cream',
                        price: '$4.25' })
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor2.stock(@item3, 25)
    @vendor2.stock(@item4, 50)
    @vendor3 = Vendor.new('Palisade Peach Shack')
    @vendor3.stock(@item1, 65)
    @market = Market.new('South Pearl Street Farmers Market')
  end

  describe '#initialize' do
    it 'exists and has attributes' do
      expect(@market).to be_a Market
      expect(@market.name).to eq('South Pearl Street Farmers Market')
    end
  end

  describe '#add_vendor' do
    it 'has vendors' do
      expect(@market.vendors).to eq([])

      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end
  end
end
