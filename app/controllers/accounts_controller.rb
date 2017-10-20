class AccountsController < ApplicationController

  # GET /accounts/new
  def new
    @account = Account.new
  end
  
  # POST /accounts/new
  def create
    @account = Account.new(account_params)
    if @account.save
      @account.send_activation_email
      flash[:success] = "<strong>Your account was created.</strong> Please confirm your email address to log in"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def confirm
    account = Account.find_by_email(params[:email])
    if account && !account.activated? && account.authenticated?(:activation, params[:id])
      account.activate
      flash[:success] = "<strong>Success!</strong> Your email was verified"
      redirect_to root_url
    elsif account.activated?
      flash[:danger] = "This account is already activated!"
      redirect_to root_url
    else
      flash[:danger] = "Sorry, this confirmation token is incorrect"
      redirect_to root_url
    end
  end
  
  private

    # Make sure that it gets only the parameters that are publicly modifiable
    def account_params
      params.require(:account).permit(:first_name, :last_name, :email, :phone, :birthdate, :password, :password_confirmation)
    end

end
