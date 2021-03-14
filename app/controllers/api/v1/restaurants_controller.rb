class Api::V1::RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant
                       .by_name(params[:name])
                       .by_date_time(params[:days])
                       .by_opens_and_closes_hours(params[:opens], params[:closes])
                       .joins(:opening_hours)
                       .includes(:opening_hours)
                       .all
                       .limit(50)
    json_response(@restaurants.as_json(include: {opening_hours: {methods: :week_day}}))
  end
end
