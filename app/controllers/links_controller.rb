require_relative '../../app/models/user'

class LinksController < ApplicationController
  before_filter :signed_in_user, only: [:new]

  # Yeah, I know this is a terrible idea...
  INVALID_SHORT_LINKS = %w[users login signup
                         logout links dashboard
                          profile]

  respond_to :json

  def new
    @link = Link.new
  end

  def create
    from_url = request.referrer.to_s
    params[:link][:total_clicks] = 0
    params[:link][:long_url] = validate_long_url(params[:link][:long_url])

    if from_url.end_with?("localhost:3000/") || from_url.end_with?("slnky.me/") || from_url.end_with?("caseyscarborough.com/")
      # UGH hackish and terrible. Will fix in near future.
      params[:link][:short_url] = Link.generate_short_link
      existing_link = existing_anonymous_link?(params[:link][:long_url])
      if (existing_link)
        @link = existing_link
      else
        @link = Link.new(params[:link])
        @link.total_clicks = 0
        @link.save(:validate => false)
      end
      short_url = "slnky.me/" + @link.short_url
      puts short_url
      respond_with @link
      return
    end

    if params[:link][:short_url] == ""
      params[:link][:short_url] = Link.generate_short_link
    end

    if reserved_word?(params[:link][:short_url])
      flash[:error] = "Sorry, that short URL is a reserved word."
      redirect_to new_link_path
      return
    end

    @user = User.find_by_remember_token(cookies[:remember_token])
    @link = @user.links.build(params[:link])
    if @link.save
      flash[:success] = "Short link slnky.me/#{@link.short_url} successfully created."
      redirect_to dashboard_path
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

    def reserved_word?(short_url)
      INVALID_SHORT_LINKS.include?(short_url)
    end

    def existing_anonymous_link?(long_url)
      link = Link.find_by_long_url_and_user_id(long_url, nil)
      if !link.nil?
        link
      else
        nil
      end
    end

end