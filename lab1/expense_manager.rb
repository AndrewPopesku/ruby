require 'json'
require 'yaml'

def add_expense(collection, description, amount, date, categories, payment_methods)
  collection[description.to_sym] = { 
    amount: amount, 
    date: date, 
    categories: categories, 
    payment_methods: payment_methods 
  }
end

def edit_expense(collection, description, new_amount = nil, new_date = nil, new_categories = nil, new_payment_methods = nil)
  return unless collection.key?(description.to_sym)

  collection[description.to_sym][:amount] = new_amount unless new_amount.nil?
  collection[description.to_sym][:date] = new_date unless new_date.nil?
  collection[description.to_sym][:categories] = new_categories unless new_categories.nil?
  collection[description.to_sym][:payment_methods] = new_payment_methods unless new_payment_methods.nil?
end

def delete_expense(collection, description)
  collection.delete(description.to_sym)
end

def search_expenses(collection, keyword)
  collection.select do |description, details|
    description.to_s.downcase.include?(keyword.downcase) ||
      details[:categories].any? { |c| c.downcase.include?(keyword.downcase) } ||
      details[:payment_methods].any? { |p| p.downcase.include?(keyword.downcase) }
  end
end

def output_expenses(collection)
  collection.each do |description, details|
    puts "\nDescription: #{description}"
    puts "Amount: #{details[:amount]}"
    puts "Date: #{details[:date]}"
    puts "Categories: #{details[:categories].join(', ')}"
    puts "Payment Methods: #{details[:payment_methods].join(', ')}"
  end
end

def save_to_json(collection, filename)
  File.write(filename, JSON.pretty_generate(collection))
end

def load_from_json(filename)
  JSON.parse(File.read(filename), symbolize_names: true) rescue {}
end

def save_to_yaml(collection, filename)
  File.write(filename, collection.to_yaml)
end

def load_from_yaml(filename)
  YAML.load_file(filename, symbolize_names: true) rescue {}
end

def main
  expenses = load_from_json("expenses.json")

  add_expense(expenses, "Groceries", 250.50, "2023-05-15", ["Food", "Daily expenses"], ["Cash"])
  add_expense(expenses, "Gasoline", 500.00, "2023-05-16", ["Transport"], ["Credit card"])
  edit_expense(expenses, "Groceries", 275.75, nil, ["Food", "Supermarket"], nil)
  delete_expense(expenses, "Gasoline")
  
  add_expense(expenses, "Cinema", 150.00, "2023-05-18", ["Entertainment", "Leisure"], ["Debit card"])

  puts "\nSearch results for 'food':"
  p search_expenses(expenses, "food")

  puts "\nCurrent expense list:"
  output_expenses(expenses)

  save_to_json(expenses, "expenses.json")
  save_to_yaml(expenses, "expenses.yml")
end

main if __FILE__ == $0 