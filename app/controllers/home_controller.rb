class HomeController < ApplicationController
  def index
    @link = Link.new
    if signed_in?
      redirect_to dashboard_path
    end
  end
end
