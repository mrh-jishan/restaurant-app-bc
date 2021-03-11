class OpeningHour < ApplicationRecord

  belongs_to :restaurant

  def week_day
    $normalize_days[self.day_of_week]
  end

end
