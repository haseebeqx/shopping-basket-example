class Basket
  attr_reader :items

  def initialize(catalogue, delivery_charge, offers = [])
    @items = Hash.new(0)
    @catalogue = catalogue
    @delivery_charge = delivery_charge
    @offers = offers || []
  end

  def add(item_code, quantity = 1)
    raise "Item not found in catalogue" unless @catalogue.find_product_by_code(item_code)

    @items[item_code] += quantity
  end

  def total
    return 0 if @items.empty?

    subtotal = @items.sum { |code, quantity| @catalogue.find_product_by_code(code).price * quantity }
    discount = @offers.sum { |offer| offer.total_discount(self) }

    subtotal -= discount
    subtotal + @delivery_charge.charge_for(subtotal)
  end
end
