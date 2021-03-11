class FavouriteItem < ApplicationRecord

  belongs_to :restaurant
  belongs_to :favourite, optional: true

end
