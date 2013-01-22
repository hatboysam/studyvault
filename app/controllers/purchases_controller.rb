class PurchasesController < ApplicationController
  
  before_filter :authenticate
  
  def create
    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => 499,
      :currency => "usd",
      :description => "StudyHeist - 10 Credits"
    )

    @purchase = Purchase.new(
      :user_id => current_user.id,
      :credits => 5,
      :good => false
    )

    if @purchase.save
      @purchase.make_good
      @purchase.user.add_credits(10);
      @purchase.user.save(:validate => false)
      UserMailer.purchase_receipt(@purchase).deliver   
      flash[:success] = "Purchase successful, credits added to your account"
    else
      charge.refund 
      flash[:error] = "Sorry, there was an error saving your purchase.  You have not been charged"
    end

    redirect_to root_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_purchase_path
  end

end

