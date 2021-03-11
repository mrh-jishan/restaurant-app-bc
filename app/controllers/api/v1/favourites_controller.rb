class Api::V1::FavouritesController < SecureController
  included :user

  def index
    @favourites = Favourite
                      .joins([{:favourite_items => [:restaurant]}, :user])
                      .includes([{:favourite_items => [:restaurant]}, :user])
                      .limit(15)

    json_response(@favourites.as_json(include: [{favourite_items: {include: :restaurant}}, :user]))
  end

  def create
    @favourite = @current_user.favourites.new(favourite_param)
    if @favourite.save
      json_response(@favourite, 201, "Added!")
    else
      resource_validation_error(@favourite)
    end
  end


  private

  def favourite_param
    params.require(:favourite).permit(:name, :favourite_items_attributes => [:restaurant_id])
  end
end
