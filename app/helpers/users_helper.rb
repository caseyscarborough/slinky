module UsersHelper

  def gravatar_for(user, size='80', css_class='')
    id = Digest::MD5::hexdigest(user.email.downcase)
    url = "https://secure.gravatar.com/avatar/#{id}?s=#{size}"
    image_tag(url, alt: user.name, class: "gravatar #{css_class}")
  end

  def total_clicks(user)
    total_clicks = 0
    user.links.each do |link|
      total_clicks += link.total_clicks
    end
    total_clicks
  end

end
