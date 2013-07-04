class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :dashboard, :edit, :update]
  before_filter :correct_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def show
    redirect_to dashboard_path
  end

  def dashboard
    @user = current_user
    @links = @user.links.paginate(page: params[:page], per_page: 15)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
      flash[:success] = "Account successfully created!"
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def edit
    redirect_to profile_path
  end

  def profile
    @user = User.find(current_user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated."
      sign_in @user
      redirect_to dashboard_path
    else
      render 'edit'
    end
  end

  private

    def signed_in_user
      store_location
      redirect_to login_path, notice: "Please login first." unless signed_in?
    end

    def correct_user
      begin
        @user = User.find(params[:id])
      rescue
        redirect_to dashboard_path
        return
      end
      redirect_to(root_path) unless current_user?(@user)
    end
end
