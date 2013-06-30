class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation
  has_secure_password

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true,
            :length => { :maximum => 100 },
            :format => { :with => EMAIL_REGEX },
            :uniqueness => { :case_sensitive => false }
  validates_confirmation_of :password
  validates :password_confirmation, :presence => true,
            :length => { :minimum => 6 }

end
