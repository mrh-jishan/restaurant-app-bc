class Api::V1::RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant
                       .by_name(params[:name])
                       .by_date_time(params[:start], params[:ends])
                       .joins(:opening_hours)
                       .includes(:opening_hours)
                       .all
                       .limit(15)
    json_response(@restaurants.as_json(include: {opening_hours: {methods: :week_day}}))
  end
end
