class Link < ActiveRecord::Base
  attr_accessible :last_visited, :long_url, :short_url,
                  :total_clicks
  belongs_to :user

  SHORT_URL_REGEX = /[a-zA-Z0-9-_]{1,20}/

  validates :user_id, presence: true
  validates :short_url, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :long_url, presence: true
  validates :short_url, :format => SHORT_URL_REGEX

end
