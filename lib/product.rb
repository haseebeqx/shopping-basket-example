class Product
  attr_reader :name, :code, :price

  def initialize(name:, code:, price:)
    @name = name
    @code = code
    @price = price
  end

  def ==(other)
    @code == other.code
  end
end
