class Expense < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :payment_method, optional: true

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validate :date_cannot_be_in_future

  private

  def date_cannot_be_in_future
    if date.present? && date > Date.today
      errors.add(:date, "can't be in the future")
    end
  end
end
