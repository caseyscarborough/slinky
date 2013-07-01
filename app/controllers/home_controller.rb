class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to user_path(current_user)
    end
  end
end
