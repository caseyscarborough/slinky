require_relative '../../app/models/user'

class LinksController < ApplicationController
  before_filter :signed_in_user, only: [:new]

  def new
    @link = Link.new
  end

  def create
    params[:link][:total_clicks] = 0
    params[:link][:long_url] = validate_long_url(params[:link][:long_url])
    @user = User.find_by_remember_token(cookies[:remember_token])
    @link = @user.links.build(params[:link])

    if @link.save
      flash[:success] = "Short link successfully created."
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def check_for_valid_link
    short_url = request.fullpath.delete "/"
    link = Link.find_by_short_url(short_url)
    if !link.nil?
      link.total_clicks += 1
      link.last_visited = Time.new
      link.save
      redirect_to link.long_url
    else
      render template: 'links/404'
    end

  end

  private

    def signed_in_user
      store_location
      redirect_to login_url, notice: "Please login first." unless signed_in?
    end

    def validate_long_url(long_url)
      if long_url.start_with?("http://" || "https://")
        long_url
      else
        "http://" + long_url
      end
    end

end