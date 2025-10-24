# Shopping Basket

A super simple and basic shopping basket system.

## Usage

## Example script

```
ruby example.rb
```

### Usage with IRB

Start IRB and require the necessary files:

```bash
irb -r ./lib/catalogue.rb -r ./lib/basket.rb -r ./lib/offers/buy_one_get_one_for_half_price.rb -r ./lib/delivery_rule.rb
```

### Creating Products and Catalogue

You can create products manually and add them to a catalogue, or you can create a catalogue from an array of hashes:

```ruby
catalogue = Catalogue.from_array([
  { name: "Red Widget", code: "R01", price: 32.95 },
  { name: "Green Widget", code: "G01", price: 24.95 },
  { name: "Blue Widget", code: "B01", price: 7.95 }
])
```

### Accessing products from the catalogue

```ruby
red_widget = catalogue.find_product_by_code("R01")
green_widget = catalogue.find_product_by_code("G01")
```

### Creating Delivery Charge Rules

```ruby
delivery_rules = [
  DeliveryRule.new(90, 0),    # Free delivery for orders over $90
  DeliveryRule.new(50, 2.95), # $2.95 delivery for orders over $50
  DeliveryRule.new(0, 4.95)   # $4.95 delivery for orders under $50
]
```

### Creating Discounts
Currently only one offer is supported, `BuyOneGetOneForHalfPriceOffer`.
```ruby
red_widget_offer = BuyOneGetOneForHalfPriceOffer.new(red_widget)
```

### Creating Basket

```ruby
basket = Basket.new(catalogue, delivery_rules, [red_widget_offer])
```

### Adding Items to Basket
you can add items by product code. It will select the product from the catalogue

```ruby
basket.add_item("R01")      # Add 1 Red Widget
basket.add_item("G01", 2)   # Add 2 Green Widgets
basket.add_item("B01")   # Add 1 Blue Widgets

# Check basket contents
basket.items  # => {"R01"=>1, "G01"=>2, "B01"=>1}
```

### Getting Total

```ruby
basket.total
```