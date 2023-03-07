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
    all_items = @vendors.map { |vendor| vendor.inventory.keys.map(&:name) }
    all_items.flatten.uniq.sort
  end
end
