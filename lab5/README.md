# Expense Manager Rails Application

This Rails application implements an expense management system with the following features:

- Create, view, and manage expenses
- Categorize expenses with multiple categories
- Track payment methods used for each expense
- Data validations to ensure data integrity

## Models

### Expense
- **Attributes**: description, amount, date
- **Validations**:
  - Description must be present
  - Amount must be present and greater than 0
  - Date must be present and cannot be in the future
- **Associations**: 
  - Has and belongs to many Categories
  - Has and belongs to many Payment Methods

### Category
- **Attributes**: name
- **Validations**: 
  - Name must be present and unique (case-insensitive)
- **Associations**: Has and belongs to many Expenses

### PaymentMethod
- **Attributes**: name
- **Validations**: 
  - Name must be present and unique (case-insensitive)
- **Associations**: Has and belongs to many Expenses

## Database Schema

The database includes:
- `expenses` table to store expense details
- `categories` table to store expense categories
- `payment_methods` table to store payment methods
- Two join tables for many-to-many relationships:
  - `categories_expenses`
  - `expenses_payment_methods`

## Testing Models and Validations

You can test the models and validations in two ways:

### 1. Using the Interactive Test Tool

```bash
rails expense_manager:interactive_test
```

This tool allows you to:
- Create new categories
- Create new payment methods
- Create new expenses with multiple categories and payment methods
- View all data in the system

### 2. Using the Rails Console

```bash
rails console
```

Example operations:

```ruby
# Create a category
food = Category.create(name: "Food")

# Create a payment method
credit_card = PaymentMethod.create(name: "Credit Card")

# Create an expense
expense = Expense.new(
  description: "Lunch",
  amount: 15.50,
  date: Date.today
)
expense.categories << food
expense.payment_methods << credit_card
expense.save

# Test validations
invalid_expense = Expense.create(amount: -5, date: Date.today + 1)
# This will fail because of negative amount and future date
invalid_expense.errors.full_messages
# => ["Amount must be greater than 0", "Date can't be in the future"]
```

## Setup and Installation

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails db:seed` to load sample data
5. Run `rails expense_manager:interactive_test` to test models interactively
