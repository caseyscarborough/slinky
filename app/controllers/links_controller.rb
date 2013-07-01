class LinksController < ApplicationController


  def check_for_valid_link
    short_url = request.fullpath.delete "/"
    link = Link.find_by_short_url(short_url)
    if link
      link.total_clicks += 1
      link.last_visited = Time.new
      link.save
      redirect_to link.long_url
    else
      render template: 'links/404', layout: "blank"
    end

  end

end