require 'json'
require 'yaml'
require_relative 'expense'

class ExpenseManager
  def initialize
    @expenses = {}
  end

  def add_expense(description, amount, date, categories, payment_methods)
    expense = Expense.new(description.to_sym, amount, date, categories, payment_methods)
    @expenses[description.to_sym] = expense
    expense
  end

  def edit_expense(description, new_description = nil, new_amount = nil, new_date = nil, new_categories = nil, new_payment_methods = nil)
    return nil unless @expenses.key?(description.to_sym)
    
    expense = @expenses[description.to_sym]
    
    if new_description && !new_description.empty? && new_description.to_sym != description.to_sym
      @expenses.delete(description.to_sym)
      expense.description = new_description.to_sym
      @expenses[new_description.to_sym] = expense
    end
    
    expense.amount = new_amount if new_amount
    expense.date = new_date if new_date
    expense.categories = new_categories if new_categories
    expense.payment_methods = new_payment_methods if new_payment_methods
    
    expense
  end

  def delete_expense(description)
    @expenses.delete(description.to_sym)
  end

  def search_expenses(keyword)
    @expenses.select { |_, expense| expense.matches?(keyword) }
  end

  def all_expenses
    @expenses
  end

  def save_to_json(filename)
    hash_data = @expenses.transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(hash_data))
  end

  def load_from_json(filename)
    return false unless File.exist?(filename)
    
    json_data = JSON.parse(File.read(filename), symbolize_names: true)
    @expenses = {}
    
    json_data.each do |description, data|
      @expenses[description] = Expense.from_h(data)
    end
    
    true
  rescue JSON::ParserError
    false
  end

  def save_to_yaml(filename)
    hash_data = @expenses.transform_values(&:to_h)
    File.write(filename, hash_data.to_yaml)
  end

  def load_from_yaml(filename)
    return false unless File.exist?(filename)
    
    yaml_data = YAML.load_file(filename, symbolize_names: true)
    @expenses = {}
    
    yaml_data.each do |description, data|
      @expenses[description] = Expense.from_h(data)
    end
    
    true
  rescue Psych::SyntaxError
    false
  end
end 