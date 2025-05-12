require 'json'
require 'yaml'

# Declare expenses as a global variable
$expenses = {}

def add_expense
  print 'Description: '
  description = gets.chomp.to_sym

  print 'Amount: '
  amount = gets.chomp.to_f

  print 'Date (YYYY-MM-DD): '
  date = gets.chomp

  print 'Categories (comma-separated): '
  categories = gets.chomp.split(',').map(&:strip)

  print 'Payment methods (comma-separated): '
  payment_methods = gets.chomp.split(',').map(&:strip)

  $expenses[description] = { 
    amount: amount, 
    date: date, 
    categories: categories, 
    payment_methods: payment_methods 
  }
end

def edit_expense
  print 'Enter expense description: '
  description = gets.chomp.to_sym

  return puts 'Expense not found' unless $expenses.key?(description)

  print 'Enter new description (or leave empty to not change): '
  new_description = gets.chomp.to_sym
  $expenses[new_description] = $expenses.delete(description) unless new_description.empty? || new_description == description

  updated_description = new_description.empty? ? description : new_description

  print 'Enter new amount (or leave empty to not change): '
  new_amount = gets.chomp
  $expenses[updated_description][:amount] = new_amount.to_f unless new_amount.empty?

  print 'Enter new date (YYYY-MM-DD, or leave empty to not change): '
  new_date = gets.chomp
  $expenses[updated_description][:date] = new_date unless new_date.empty?

  print 'Enter new categories (comma-separated, or leave empty to not change): '
  new_categories = gets.chomp
  $expenses[updated_description][:categories] = new_categories.split(',').map(&:strip) unless new_categories.empty?

  print 'Enter new payment methods (comma-separated, or leave empty to not change): '
  new_payment_methods = gets.chomp
  $expenses[updated_description][:payment_methods] = new_payment_methods.split(',').map(&:strip) unless new_payment_methods.empty?
end

def delete_expense
  print 'Enter expense description to delete: '
  description = gets.chomp.to_sym
  $expenses.delete(description) || puts('Expense not found')
end

def search_expense
  print 'What are you searching for: '
  query = gets.chomp.downcase

  results = $expenses.select do |description, details|
    description.to_s.downcase.include?(query) ||
      details[:categories].any? { |c| c.downcase.include?(query) } ||
      details[:payment_methods].any? { |p| p.downcase.include?(query) }
  end

  puts "Found #{results.size} expenses:"
  results.each do |description, details|
    puts "Description: #{description}, Amount: #{details[:amount]}, Date: #{details[:date]}, " \
         "Categories: #{details[:categories].join(', ')}, Payment Methods: #{details[:payment_methods].join(', ')}"
  end
end

def save_to_file(format)
  print 'Name of file to save (without extension): '
  filename = gets.chomp

  case format
  when :json
    File.write("#{filename}.json", JSON.pretty_generate($expenses))
    puts "Saved to #{filename}.json"
  when :yaml
    File.write("#{filename}.yml", $expenses.to_yaml)
    puts "Saved to #{filename}.yml"
  end
end

def load_from_file
  print 'Enter file path to load (include extension .json or .yml): '
  filename = gets.chomp
  
  if File.exist?(filename)
    if filename.end_with?('.json')
      $expenses = JSON.parse(File.read(filename), symbolize_names: true)
      puts "Loaded from #{filename}"
    elsif filename.end_with?('.yml')
      $expenses = YAML.load_file(filename, symbolize_names: true)
      puts "Loaded from #{filename}"
    else
      puts "Unsupported file format. Please use .json or .yml files."
    end
  else
    puts "File not found: #{filename}"
  end
end

def output_expenses(collection)
  if collection.empty?
    puts "No expenses to display"
    return
  end
  
  collection.each do |description, details|
    puts "\nDescription: #{description}"
    puts "Amount: #{details[:amount]}"
    puts "Date: #{details[:date]}"
    puts "Categories: #{details[:categories].join(', ')}"
    puts "Payment Methods: #{details[:payment_methods].join(', ')}"
  end
end

def show
  output_expenses($expenses)
end

puts "Expense Manager"
puts "==============="

loop do
  puts "\n1. Add expense"
  puts '2. Edit expense'
  puts '3. Delete expense'
  puts '4. Search expense'
  puts '5. Save to JSON'
  puts '6. Save to YAML'
  puts '7. Load from file'
  puts '8. Show all expenses'
  puts '9. Exit'
  print 'Choose an option: '

  case gets.to_i
  when 1 then add_expense
  when 2 then edit_expense
  when 3 then delete_expense
  when 4 then search_expense
  when 5 then save_to_file(:json)
  when 6 then save_to_file(:yaml)
  when 7 then load_from_file
  when 8 then show
  when 9 then break
  else puts 'Incorrect choice'
  end
end 