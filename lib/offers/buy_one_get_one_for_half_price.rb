require_relative 'offer'
require_relative 'buy_x_get_x_offer'

class BuyOneGetOneForHalfPriceOffer < BuyXGetYOffer
  def initialize(product)
    @product = product
  end

  def total_discount(basket)
    quantity = basket.items[@product.code]
    return 0 if quantity < 2

    times_applicable = quantity / 2
    times_applicable * @product.price / 2
  end
end
