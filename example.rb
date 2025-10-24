require_relative 'lib/catalogue'
require_relative 'lib/basket'
require_relative 'lib/offers/buy_one_get_one_for_half_price'
require_relative 'lib/delivery_charge'

puts "Creating catalogue"
catalogue = Catalogue.from_array([
  { name: "Red Widget", code: "R01", price: 32.95 },
  { name: "Green Widget", code: "G01", price: 24.95 },
  { name: "Blue Widget", code: "B01", price: 7.95 }
])

puts "Creating delivery rules"
delivery_rules = [
  DeliveryCharge::DeliveryRule.new(90, 0),    # Free delivery for orders over $90
  DeliveryCharge::DeliveryRule.new(50, 2.95), # $2.95 delivery for orders over $50
  DeliveryCharge::DeliveryRule.new(0, 4.95)   # $4.95 delivery for orders under $50
]

puts "Creating delivery charge"
delivery_charge = DeliveryCharge.new(delivery_rules)

puts "Creating offers"
red_widget = catalogue.find_product_by_code("R01")
red_widget_offer = BuyOneGetOneForHalfPriceOffer.new(red_widget)

puts "Creating basket"
basket = Basket.new(catalogue, delivery_charge, [red_widget_offer])

puts "Empty basket total: $#{basket.total.truncate(2)}"

puts "Adding items"
basket.add("R01", 2)  # 2 Red Widgets (offer applies)
basket.add("G01")     # 1 Green Widget
basket.add("B01")     # 1 Blue Widget

puts "Getting total"
puts "Total: $#{basket.total.truncate(2)}"

puts "TEST 1"

basket = Basket.new(catalogue, delivery_charge, [red_widget_offer])
basket.add("B01")
basket.add("G01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $37.85"

puts "TEST 2"

basket = Basket.new(catalogue, delivery_charge, [red_widget_offer])

basket.add("R01")
basket.add("R01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $54.37"

puts "TEST 3"

basket = Basket.new(catalogue, delivery_charge, [red_widget_offer])

basket.add("R01")
basket.add("G01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $60.85"

puts "TEST 4"

basket = Basket.new(catalogue, delivery_charge, [red_widget_offer])

basket.add("B01")
basket.add("B01")
basket.add("R01")
basket.add("R01")
basket.add("R01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $98.27"
