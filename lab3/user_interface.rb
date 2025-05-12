require_relative 'expense_manager'

class ExpenseConsole
  def initialize
    @expense_manager = ExpenseManager.new
  end

  def run
    puts "Expense Manager"
    puts "==============="

    loop do
      display_menu
      handle_choice(gets.to_i)
    end
  end

  private

  def display_menu
    puts "\n1. Add expense"
    puts "2. Edit expense"
    puts "3. Delete expense"
    puts "4. Search expenses"
    puts "5. Save to JSON"
    puts "6. Save to YAML"
    puts "7. Load from file"
    puts "8. Show all expenses"
    puts "9. Exit"
    print "Choose an option: "
  end

  def handle_choice(choice)
    case choice
    when 1 then add_expense
    when 2 then edit_expense
    when 3 then delete_expense
    when 4 then search_expenses
    when 5 then save_to_json
    when 6 then save_to_yaml
    when 7 then load_from_file
    when 8 then show_all_expenses
    when 9 then exit
    else puts "Incorrect choice"
    end
  end

  def add_expense
    print "Description: "
    description = gets.chomp

    print "Amount: "
    amount = gets.chomp.to_f

    print "Date (YYYY-MM-DD): "
    date = gets.chomp

    print "Categories (comma-separated): "
    categories = gets.chomp.split(',').map(&:strip)

    print "Payment methods (comma-separated): "
    payment_methods = gets.chomp.split(',').map(&:strip)

    @expense_manager.add_expense(description, amount, date, categories, payment_methods)
    puts "Expense added successfully."
  end

  def edit_expense
    print "Enter expense description: "
    description = gets.chomp

    unless @expense_manager.all_expenses.key?(description.to_sym)
      puts "Expense not found"
      return
    end

    print "Enter new description (or leave empty to not change): "
    new_description = gets.chomp

    print "Enter new amount (or leave empty to not change): "
    new_amount_input = gets.chomp
    new_amount = new_amount_input.empty? ? nil : new_amount_input.to_f

    print "Enter new date (YYYY-MM-DD, or leave empty to not change): "
    new_date = gets.chomp.empty? ? nil : gets.chomp

    print "Enter new categories (comma-separated, or leave empty to not change): "
    new_categories_input = gets.chomp
    new_categories = new_categories_input.empty? ? nil : new_categories_input.split(',').map(&:strip)

    print "Enter new payment methods (comma-separated, or leave empty to not change): "
    new_payment_methods_input = gets.chomp
    new_payment_methods = new_payment_methods_input.empty? ? nil : new_payment_methods_input.split(',').map(&:strip)

    @expense_manager.edit_expense(
      description, 
      new_description.empty? ? nil : new_description,
      new_amount,
      new_date,
      new_categories,
      new_payment_methods
    )
    puts "Expense updated successfully."
  end

  def delete_expense
    print "Enter expense description to delete: "
    description = gets.chomp
    
    if @expense_manager.delete_expense(description)
      puts "Expense deleted successfully."
    else
      puts "Expense not found."
    end
  end

  def search_expenses
    print "What are you searching for: "
    query = gets.chomp.downcase

    results = @expense_manager.search_expenses(query)
    
    puts "Found #{results.size} expenses:"
    results.each do |_, expense|
      puts expense
    end
  end

  def save_to_json
    print "Name of file to save (without extension): "
    filename = gets.chomp
    
    @expense_manager.save_to_json("#{filename}.json")
    puts "Saved to #{filename}.json"
  end

  def save_to_yaml
    print "Name of file to save (without extension): "
    filename = gets.chomp
    
    @expense_manager.save_to_yaml("#{filename}.yml")
    puts "Saved to #{filename}.yml"
  end

  def load_from_file
    print "Enter file path to load (include extension .json or .yml): "
    filename = gets.chomp
    
    if File.exist?(filename)
      if filename.end_with?('.json')
        if @expense_manager.load_from_json(filename)
          puts "Loaded from #{filename}"
        else
          puts "Error loading JSON file."
        end
      elsif filename.end_with?('.yml')
        if @expense_manager.load_from_yaml(filename)
          puts "Loaded from #{filename}"
        else
          puts "Error loading YAML file."
        end
      else
        puts "Unsupported file format. Please use .json or .yml files."
      end
    else
      puts "File not found: #{filename}"
    end
  end

  def show_all_expenses
    expenses = @expense_manager.all_expenses
    
    if expenses.empty?
      puts "No expenses to display"
      return
    end
    
    expenses.each do |_, expense|
      puts "\n#{expense}"
    end
  end
end 