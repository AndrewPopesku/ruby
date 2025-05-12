class Expense
  attr_accessor :description, :amount, :date, :categories, :payment_methods

  def initialize(description, amount, date, categories = [], payment_methods = [])
    @description = description
    @amount = amount
    @date = date
    @categories = categories
    @payment_methods = payment_methods
  end

  def to_h
    {
      description: @description,
      amount: @amount,
      date: @date,
      categories: @categories,
      payment_methods: @payment_methods
    }
  end

  def self.from_h(hash)
    new(
      hash[:description],
      hash[:amount],
      hash[:date],
      hash[:categories],
      hash[:payment_methods]
    )
  end

  def matches?(keyword)
    keyword = keyword.downcase
    @description.to_s.downcase.include?(keyword) ||
      @categories.any? { |c| c.downcase.include?(keyword) } ||
      @payment_methods.any? { |p| p.downcase.include?(keyword) }
  end

  def to_s
    "Description: #{@description}, Amount: #{@amount}, Date: #{@date}, " \
    "Categories: #{@categories.join(', ')}, Payment Methods: #{@payment_methods.join(', ')}"
  end
end 