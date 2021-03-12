class Restaurant < ApplicationRecord

  default_scope { order(created_at: :desc) }

  has_many :opening_hours
  # belongs_to :favourite_item

  validates_presence_of :name


  scope :by_name, ->(value) { where("name ILIKE ?", "%#{value}%") }
  scope :by_date_time, ->(start, ends) { joins(:opening_hours).where(:opening_hours => {day_of_week: start..ends}) }

end
