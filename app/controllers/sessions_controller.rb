class SessionsController < ApplicationController

  def new
    if signed_in?
      redirect_to root_url
    end
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to dashboard_path
    else
      flash[:error] = "Username/password combination could not be found."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
