class DeliveryCharge
  DeliveryRule = Struct.new(:threshold, :charge)

  def initialize(rules)
    raise "Delivery charge rules not provided" if rules.nil? || rules.empty?
    @rules = rules.sort_by(&:threshold).reverse
  end

  def charge_for(subtotal)
    rule = @rules.find { |rule| subtotal >= rule.threshold }
    rule.charge
  end
end
