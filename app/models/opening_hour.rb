class OpeningHour < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of :opens, :closes, :day_of_week

  def week_day
    $normalize_days[self.day_of_week]
  end

end
