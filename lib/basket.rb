class Basket
  attr_reader :items

  def initialize(catalogue, delivery_charge_rules, offers = [])
    @items = Hash.new(0)
    @catalogue = catalogue
    raise "Delivery charge rules not provided" if delivery_charge_rules.nil? || delivery_charge_rules.empty?

    @delivery_charge_rules = delivery_charge_rules.sort_by(&:threshold).reverse
    @offers = offers
  end

  def add_item(item_code, quantity = 1)
    raise "Item not found in catalogue" unless @catalogue.find_product_by_code(item_code)

    @items[item_code] += quantity
  end

  def total
    return 0 if @items.empty?

    subtotal = 0
    @items.each do |item_code, quantity|
      product = @catalogue.find_product_by_code(item_code)
      subtotal += product.price * quantity
    end

    subtotal -= apply_offers
    subtotal += delivery_charge_for(subtotal)
    subtotal
  end

  private

  def delivery_charge_for(subtotal)
    charge = @delivery_charge_rules.find do |rule|
      subtotal >= rule.threshold
    end
    charge.charge
  end

  def apply_offers
    return 0 if @offers.nil? || @offers.empty?

    discount = 0
    @offers.each do |offer|
      discount += offer.total_discount(self)
    end
    discount
  end
end
