class BuyXGetYOffer < Offer
  attr_accessor :buy_product, :get_product, :buy_quantity, :get_quantity, :discount_percentage

  def initialize(buy_product:, get_product:, buy_quantity:, get_quantity:, discount_percentage: 100)
    @buy_product = buy_product
    @get_product = get_product
    @buy_quantity = buy_quantity
    @get_quantity = get_quantity
    @discount_percentage = discount_percentage
  end
end
