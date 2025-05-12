#!/usr/bin/env ruby
# This script demonstrates the validation rules for models in the expense manager app

require_relative 'config/environment'

puts "=== MODEL VALIDATION TESTING ==="
puts "\n"

# CATEGORY VALIDATIONS
puts "TESTING CATEGORY VALIDATIONS"
puts "============================"

# Valid category
puts "Creating valid category:"
valid_category = Category.new(name: "Groceries")
if valid_category.valid?
  valid_category.save
  puts "SUCCESS: Category is valid and saved with ID: #{valid_category.id}"
else
  puts "ERROR: Category should be valid but has errors: #{valid_category.errors.full_messages.join(', ')}"
end

# Invalid category - blank name
puts "\nCreating category with blank name:"
invalid_category1 = Category.new(name: "")
if invalid_category1.valid?
  puts "ERROR: Category should be invalid but was accepted"
else
  puts "SUCCESS: Category is correctly invalid. Errors: #{invalid_category1.errors.full_messages.join(', ')}"
end

# Invalid category - duplicate name
puts "\nCreating category with duplicate name:"
duplicate_category = Category.new(name: "Groceries")
if duplicate_category.valid?
  puts "ERROR: Duplicate category should be invalid but was accepted"
else
  puts "SUCCESS: Duplicate category is correctly invalid. Errors: #{duplicate_category.errors.full_messages.join(', ')}"
end

# Case insensitive duplicate check
puts "\nCreating category with case-insensitive duplicate name:"
case_insensitive_duplicate = Category.new(name: "groceries")
if case_insensitive_duplicate.valid?
  puts "ERROR: Case-insensitive duplicate should be invalid but was accepted"
else
  puts "SUCCESS: Case-insensitive duplicate is correctly invalid. Errors: #{case_insensitive_duplicate.errors.full_messages.join(', ')}"
end

# PAYMENT METHOD VALIDATIONS
puts "\n\nTESTING PAYMENT METHOD VALIDATIONS"
puts "=================================="

# Valid payment method
puts "Creating valid payment method:"
valid_payment = PaymentMethod.new(name: "Credit Card")
if valid_payment.valid?
  valid_payment.save
  puts "SUCCESS: Payment method is valid and saved with ID: #{valid_payment.id}"
else
  puts "ERROR: Payment method should be valid but has errors: #{valid_payment.errors.full_messages.join(', ')}"
end

# Invalid payment method - blank name
puts "\nCreating payment method with blank name:"
invalid_payment = PaymentMethod.new(name: "")
if invalid_payment.valid?
  puts "ERROR: Payment method should be invalid but was accepted"
else
  puts "SUCCESS: Payment method is correctly invalid. Errors: #{invalid_payment.errors.full_messages.join(', ')}"
end

# Invalid payment method - duplicate name
puts "\nCreating payment method with duplicate name:"
duplicate_payment = PaymentMethod.new(name: "Credit Card")
if duplicate_payment.valid?
  puts "ERROR: Duplicate payment method should be invalid but was accepted"
else
  puts "SUCCESS: Duplicate payment method is correctly invalid. Errors: #{duplicate_payment.errors.full_messages.join(', ')}"
end

# EXPENSE VALIDATIONS
puts "\n\nTESTING EXPENSE VALIDATIONS"
puts "=========================="

# Valid expense
puts "Creating valid expense:"
valid_expense = Expense.new(
  description: "Weekly groceries",
  amount: 75.50,
  date: Date.today
)
valid_expense.categories << valid_category
valid_expense.payment_methods << valid_payment
if valid_expense.valid?
  valid_expense.save
  puts "SUCCESS: Expense is valid and saved with ID: #{valid_expense.id}"
else
  puts "ERROR: Expense should be valid but has errors: #{valid_expense.errors.full_messages.join(', ')}"
end

# Invalid expense - blank description
puts "\nCreating expense with blank description:"
invalid_expense1 = Expense.new(
  description: "",
  amount: 50.00,
  date: Date.today
)
if invalid_expense1.valid?
  puts "ERROR: Expense should be invalid but was accepted"
else
  puts "SUCCESS: Expense is correctly invalid. Errors: #{invalid_expense1.errors.full_messages.join(', ')}"
end

# Invalid expense - zero amount
puts "\nCreating expense with zero amount:"
invalid_expense2 = Expense.new(
  description: "Test expense",
  amount: 0,
  date: Date.today
)
if invalid_expense2.valid?
  puts "ERROR: Expense should be invalid but was accepted"
else
  puts "SUCCESS: Expense is correctly invalid. Errors: #{invalid_expense2.errors.full_messages.join(', ')}"
end

# Invalid expense - negative amount
puts "\nCreating expense with negative amount:"
invalid_expense3 = Expense.new(
  description: "Test expense",
  amount: -10.00,
  date: Date.today
)
if invalid_expense3.valid?
  puts "ERROR: Expense should be invalid but was accepted"
else
  puts "SUCCESS: Expense is correctly invalid. Errors: #{invalid_expense3.errors.full_messages.join(', ')}"
end

# Invalid expense - future date
puts "\nCreating expense with future date:"
invalid_expense4 = Expense.new(
  description: "Future expense",
  amount: 25.00,
  date: Date.today + 10 # 10 days in the future
)
if invalid_expense4.valid?
  puts "ERROR: Expense with future date should be invalid but was accepted"
else
  puts "SUCCESS: Expense with future date is correctly invalid. Errors: #{invalid_expense4.errors.full_messages.join(', ')}"
end

# ASSOCIATION TESTS
puts "\n\nTESTING ASSOCIATIONS"
puts "===================="

# Create another category and payment method
second_category = Category.create(name: "Entertainment")
second_payment = PaymentMethod.create(name: "Cash")

# Create an expense with multiple categories and payment methods
puts "Creating expense with multiple categories and payment methods:"
multi_assoc_expense = Expense.new(
  description: "Birthday party",
  amount: 150.00,
  date: Date.yesterday
)
multi_assoc_expense.categories << valid_category
multi_assoc_expense.categories << second_category
multi_assoc_expense.payment_methods << valid_payment
multi_assoc_expense.payment_methods << second_payment
if multi_assoc_expense.save
  puts "SUCCESS: Expense with multiple associations saved with ID: #{multi_assoc_expense.id}"
  puts "   - Categories: #{multi_assoc_expense.categories.map(&:name).join(', ')}"
  puts "   - Payment Methods: #{multi_assoc_expense.payment_methods.map(&:name).join(', ')}"
else
  puts "ERROR: Expense with multiple associations should save but failed: #{multi_assoc_expense.errors.full_messages.join(', ')}"
end

puts "\n"
puts "=== VALIDATION TESTING COMPLETE ==="