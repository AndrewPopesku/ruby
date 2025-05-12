class AddPaymentMethodReferenceToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_reference :expenses, :payment_method, null: true, foreign_key: true
    drop_table :expenses_payment_methods
  end
end
