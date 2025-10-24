# Shopping Basket

A super simple and basic shopping basket system.

## Assumptions

* The return value of `basket.total` is not rounded. it is up to the caller to round the value if needed.
* The value of `basket.total` is real time.
* Since only one offer type is supported, there is no need to check for overlapping offers and conflicts in this state.
* Tests are not provided due to time constraints.
* DeliveryRule is a simple struct and does not have any logic. This can be expanded to include more complex logic if needed.


## How it works

The shopping basket system is built around several core components that work together to calculate order totals with discounts and delivery charges:

> [!TIP]  
> Usage instructions are provided in the [Usage](#usage) section.

### Core Components

1. **Product**: Represents individual items with a name, unique code, and price
2. **Catalogue**: Manages a collection of products and provides lookup functionality by product code
3. **Basket**: The main shopping cart that holds items and calculates totals
4. **DeliveryRule**: delivery charges based on order value thresholds
5. **Offers**: Discount mechanisms that can be applied to specific products

### System Flow

#### 1. Initialization
- A **Catalogue** is created with available products
- **DeliveryRules** are defined with thresholds and corresponding charges
- **Offers** are created for specific products (currently only "Buy One Get One for Half Price")
- A **Basket** is initialized with the catalogue, delivery rules, and offers

#### 2. Adding Items
- Items are added to the basket using product codes
- The basket validates that products exist in the catalogue
- Item quantities are tracked in a hash structure, {product_code => quantity}

#### 3. Total Calculation
When `basket.total` is called, the system follows this sequence:

1. **Calculate Subtotal**: Sum of all item prices per quantity
2. **Apply Offers**: Calculate and subtract any applicable discounts
3. **Add Delivery Charge**: Determine the appropriate delivery charge based on the subtotal after discounts
4. **Return Final Total**: (Subtotal - discounts) + delivery charge

### Delivery Charge Logic
Delivery rules are processed in sorted order, and the first rule where the subtotal meets the threshold is applied.

This is the given example:
- Orders ≥ $90: Free delivery ($0)
- Orders ≥ $50: $2.95 delivery
- Orders < $50: $4.95 delivery

### Offer System
Currently supports "Buy One Get One for Half Price" only. Basically it applies a 50% discount to every second item of the same product this offer is applied to.


## Usage

## Example script

This includes a basic example and given tests.

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
basket.add("R01")      # Add 1 Red Widget
basket.add("G01", 2)   # Add 2 Green Widgets
basket.add("B01")      # Add 1 Blue Widgets

# Check basket contents
basket.items  # => {"R01"=>1, "G01"=>2, "B01"=>1}
```

### Getting Total

```ruby
basket.total
```
