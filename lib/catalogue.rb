require_relative 'product'

class Catalogue
  def self.from_array(products)
    new(products.map { |hash| Product.new(**hash) })
  end

  def initialize(products)
    @products = products.to_h { |product| [product.code, product] }
  end

  def find_product_by_code(code)
    @products[code]
  end
end
