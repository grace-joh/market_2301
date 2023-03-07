require 'spec_helper'

RSpec.describe Vendor do
  before(:each) do
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
      expect(@market.date).to eq(Date.today)
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

  describe '#vendor_names' do
    it 'can list all vendors names' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendor_names).to eq(['Rocky Mountain Fresh', 'Ba-Nom-a-Nom', 'Palisade Peach Shack'])
    end
  end

  describe '#vendors_that_sell' do
    it 'can list vendors that sell a specific item' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  describe '#sorted_item_list' do
    it 'lists the names of all items the markets vendors have in stock alphabetically' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sorted_item_list).to eq(['Banana Nice Cream', 'Peach', 'Peach-Raspberry Nice Cream', 'Tomato'])
    end
  end

  describe '#all_items' do
    it 'lists all unique items sold at the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.all_items).to eq([@item1, @item2, @item3, @item4])
    end
  end

  describe '#total_inventory' do
    it 'reports the quantities of all items sold at the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expected = { @item1 => { 'Quantity' => 100,
                               'Vendors' => [@vendor1, @vendor3] },
                   @item2 => { 'Quantity' => 7,
                               'Vendors' => [@vendor1] },
                   @item3 => { 'Quantity' => 25,
                               'Vendors' => [@vendor2] },
                   @item4 => { 'Quantity' => 50,
                               'Vendors' => [@vendor2] } }

      expect(@market.total_inventory).to eq(expected)
    end
  end

  describe '#total_quantity' do
    it 'lists the total quantity of an item sold by all vendors in the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.total_quantity(@item1)).to eq(100)
      expect(@market.total_quantity(@item2)).to eq(7)
      expect(@market.total_quantity(@item3)).to eq(25)
      expect(@market.total_quantity(@item4)).to eq(50)
    end
  end

  describe '#overstocked_items' do
    it 'lists all items that are sold by more than one vendor and total quanity is greater than 50' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.overstocked_items).to eq([@item1])

      @vendor3.stock(@item3, 26)

      expect(@market.overstocked_items).to eq([@item1, @item3])
    end
  end

  describe '#sell' do
    it 'returns false if there is not enough of the item to sell' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sell(@item1, 200)).to eq(false)
      expect(@vendor1.check_stock(@item1)).to eq(35)
      expect(@vendor3.check_stock(@item1)).to eq(65)
    end

    it 'returns true if there is enough of the item to sell and reduces amount by stock intake' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sell(@item1, 40)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(60)

      @vendor2.stock(@item1, 10)

      expect(@market.sell(@item1, 65)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor2.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(5)
    end

    it 'sells items in the order vendors were added' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor3)
      @market.add_vendor(@vendor2)
      @vendor2.stock(@item1, 10)

      expect(@market.sell(@item1, 40)).to eq(true)
      expect(@market.sell(@item1, 62)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor2.check_stock(@item1)).to eq(8)
      expect(@vendor3.check_stock(@item1)).to eq(0)
    end
  end
end
