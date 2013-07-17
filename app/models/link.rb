class Link < ActiveRecord::Base
  attr_accessible :last_visited, :long_url, :short_url,
                  :total_clicks
  belongs_to :user

  SHORT_URL_REGEX = /[a-zA-Z0-9\-_]{1,20}/

  validates :user_id, presence: true
  validates :short_url, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :long_url, presence: true
  validates :short_url, :format => SHORT_URL_REGEX

  def self.generate_short_link
    short_url = nil
    loop do
      rand_char =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
      short_url = (0...4).map{ rand_char[rand(rand_char.length)] }.join
      break if !Link.short_url_exists?(short_url)
    end
    short_url
  end

  private

  def self.short_url_exists?(short_url)
    link = Link.find_by_short_url(short_url)
    link
  end
end
