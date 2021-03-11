class Restaurant < ApplicationRecord
  has_many :opening_hours

  default_scope { order(created_at: :desc) }

  scope :by_name, ->(value) { where("name ILIKE ?", "%#{value}%") }
  scope :by_date_time, ->(start, ends) { joins(:opening_hours).where(:opening_hours => {day_of_week: start..ends}) }

end
