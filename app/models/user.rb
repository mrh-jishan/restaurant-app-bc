class User < ApplicationRecord

  has_many :favourites

  validates :name, :presence => true, :length => {maximum: 120}
  validates :username, :presence => true, :length => {minimum: 6, maximum: 15}, :uniqueness => {case_sensitive: false}
  validates :password, :length => {minimum: 6}

  has_secure_password

  before_save { username.downcase! }

end
