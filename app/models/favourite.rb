class Favourite < ApplicationRecord

  default_scope { order(created_at: :desc) }

  has_many :favourite_items
  accepts_nested_attributes_for :favourite_items, :allow_destroy => true
  validates_associated :favourite_items

  belongs_to :user

  validates :name, presence: true, uniqueness: true
end
