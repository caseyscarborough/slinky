class Link < ActiveRecord::Base
  attr_accessible :last_visited, :long_url, :short_url,
                  :total_clicks
  belongs_to :user

  validates :user_id, presence: true
  validates :short_url, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :long_url, presence: true
end
