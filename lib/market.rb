class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.select { |vendor| vendor.inventory.include?(item) }
  end

  def sorted_item_list
    all_items.map(&:name).sort
  end

  def all_items
    @vendors.map { |vendor| vendor.inventory.keys }.flatten.uniq
  end

  def total_inventory
    all_items.map do |item|
      item_details = [['Quantity', total_quantity(item)], ['Vendors', vendors_that_sell(item)]].to_h
      [item, item_details]
    end.to_h
  end

  def total_quantity(item)
    item_quantities = @vendors.map { |vendor| vendor.inventory[item] }
    item_quantities.sum
  end

  def overstocked_items
    all_items.select { |item| vendors_that_sell(item).count > 1 && total_quantity(item) > 50}
  end
end
