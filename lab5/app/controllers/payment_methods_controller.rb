class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:show, :edit, :update, :destroy]

  def index
    @payment_methods = PaymentMethod.all.order(:name)
  end

  def show
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)

    if @payment_method.save
      redirect_to @payment_method, notice: 'Payment method was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to @payment_method, notice: 'Payment method was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @payment_method.expenses.any?
      redirect_to payment_methods_path, alert: 'Cannot delete payment method with associated expenses.'
    else
      @payment_method.destroy
      redirect_to payment_methods_path, notice: 'Payment method was successfully deleted.'
    end
  end

  private

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end
end
