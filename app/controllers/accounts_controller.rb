class AccountsController < ApplicationController

  # GET /accounts/new
  def new
    @account = Account.new
  end
  
  # POST /accounts/new
  def create
    @account = Account.new(account_params)
    if @account.save
      AccountMailer.registration_confirmation(@account).deliver
      flash[:success] = "<strong>Your account was created.</strong> Please confirm your email address to log in"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def confirm
    account = Account.find_by_token(params[:id])
    if account
      account.activate
      flash[:success] = "<strong>Success!</strong> Your email was verified"
      redirect_to root_url
    else
      flash.now[:danger] = "Sorry, this confirmation token is incorrect"
      redirect_to root_url
    end
  end

  # GET /accounts/1/edit
  def edit
  end
  
  private

    # Make sure that it gets only the parameters that are publicly modifiable
    def account_params
      params.require(:account).permit(:first_name, :last_name, :email, :phone, :birthdate, :password, :password_confirmation)
    end

end
