require_relative '../../app/models/user'

class LinksController < ApplicationController
  before_filter :signed_in_user, only: [:new]

  INVALID_SHORT_LINKS = %w[users login signup
                         logout links dashboard]

  def new
    @link = Link.new
  end

  def create
    if params[:link][:short_url] == ""
      puts "FUCK YES"
      puts generate_short_link
      params[:link][:short_url] = generate_short_link
      puts params[:short_url]
    else
      puts "FAILURE"
    end
    generate_short_link
    if reserved_word?(params[:link][:short_url])
      flash[:error] = "Sorry, that short URL is a reserved word."
      redirect_to new_link_path
      return
    end
    params[:link][:total_clicks] = 0
    params[:link][:long_url] = validate_long_url(params[:link][:long_url])
    @user = User.find_by_remember_token(cookies[:remember_token])
    @link = @user.links.build(params[:link])
    if @link.save
      flash[:success] = "Short link slnky.me/#{@link.short_url} successfully created."
      redirect_to user_path(@user)
      return
    else
      render 'new'
      return
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

  def destroy
    link = Link.find(params[:id])
    if (link.user == current_user)
      link.destroy
      # Don't render anything since this should be an AJAX call.
      render :nothing => true
    else
      redirect_to root_path
    end
  end

  private

    def signed_in_user
      store_location
      redirect_to login_url, notice: "Please login first." unless signed_in?
    end

    def validate_long_url(long_url)
      if (long_url.start_with?("http://") || long_url.start_with?("https://"))
        long_url
      else
        "http://" + long_url
      end
    end

    def generate_short_link
      short_url = nil
      loop do
        rand_char =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
        short_url = (0...7).map{ rand_char[rand(rand_char.length)] }.join
        break if !short_url_exists?(short_url)
      end
      short_url
    end

    def reserved_word?(short_url)
      INVALID_SHORT_LINKS.include?(short_url)
    end

    def short_url_exists?(short_url)
      link = Link.find_by_short_url(short_url)
      link
    end

end