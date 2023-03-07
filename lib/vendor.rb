class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    return 0 unless @inventory.include?(item)

    @inventory[item]
  end

  def stock(item, amount)
    @inventory[item] += amount
  end

  def potential_revenue
    items_total_prices = @inventory.map do |item, quantity|
      item.price * quantity
    end
    items_total_prices.sum
  end
end
