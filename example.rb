require_relative 'lib/catalogue'
require_relative 'lib/basket'
require_relative 'lib/offers/buy_one_get_one_for_half_price'
require_relative 'lib/delivery_rule'

puts "Creating catalogue"
catalogue = Catalogue.from_array([
  { name: "Red Widget", code: "R01", price: 32.95 },
  { name: "Green Widget", code: "G01", price: 24.95 },
  { name: "Blue Widget", code: "B01", price: 7.95 }
])

puts "Creating delivery rules"
delivery_rules = [
  DeliveryRule.new(90, 0),    # Free delivery for orders over $90
  DeliveryRule.new(50, 2.95), # $2.95 delivery for orders over $50
  DeliveryRule.new(0, 4.95)   # $4.95 delivery for orders under $50
]

puts "Creating offers"
red_widget = catalogue.find_product_by_code("R01")
red_widget_offer = BuyOneGetOneForHalfPriceOffer.new(red_widget)

puts "Creating basket"
basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])

puts "Empty basket total: $#{basket.total.truncate(2)}"

puts "Adding items"
basket.add_item("R01", 2)  # 2 Red Widgets (offer applies)
basket.add_item("G01")     # 1 Green Widget
basket.add_item("B01")     # 1 Blue Widget

puts "Getting total"
puts "Total: $#{basket.total.truncate(2)}"

puts "TEST 1"

basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])
basket.add_item("B01")
basket.add_item("G01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $37.85"

puts "TEST 2"

basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])

basket.add_item("R01")
basket.add_item("R01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $54.37"

puts "TEST 3"

basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])

basket.add_item("R01")
basket.add_item("G01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $60.85"

puts "TEST 4"

basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])

basket.add_item("B01")
basket.add_item("B01")
basket.add_item("R01")
basket.add_item("R01")
basket.add_item("R01")
puts "Total: $#{basket.total.truncate(2)}"
puts "Expected total: $98.27"
