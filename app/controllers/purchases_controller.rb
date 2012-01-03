class PurchasesController < ApplicationController
  
  def create
    @token = params[:stripeToken]
    Stripe.api_key = "kTAsb04yQMFHdYcu5yZmyW0Gmt5DAf3M"
    @charge = Stripe::Charge.create(
      :amount => 499, # amount in cents, again
      :currency => "usd",
      :card => @token,
      :description => "StudyHeist - 10 Credits"
    )
    
    @purchase = Purchase.new(params[:purchase])
    if @purchase.save
      @purchase.make_good
      flash[:success] = "Purchase Successful"
      @purchase.user.add_credits(10);
      @purchase.user.save(false)
      UserMailer.purchase_receipt(@purchase).deliver
      redirect_to root_path
    else
      flash.now[:error] = 'Sorry, there was an error with your purchase.  You have not been charged.'
      render 'pages/index'
    end
  end
  
  def new
    @purchase = Purchase.new
  end

end

