class Api::V1::FavouritesController < SecureController
  included :user

  def index
    @favourites = @current_user.favourites
                      .joins([{:favourite_items => [:restaurant]}, :user])
                      .includes([{:favourite_items => [:restaurant]}, :user])

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

  def destroy
    @favourite = @current_user.favourites.find_by_id(params[:id])
    if @favourite.blank?
      json_response({}, 201, "Record not found")
    else
      @favourite.destroy
      json_response({}, 201, "Record deleted")
    end
  end

  def update
    @favourite = @current_user.favourites.find_by_id(params[:id])
    if @favourite.blank?
      json_response({}, 201, "Record not found")
    else
      @favourite.update_attribute(:name, params[:name])
      json_response({}, 201, "Record updated")
    end
  end


  private

  def favourite_param
    params.require(:favourite).permit(:name, :favourite_items_attributes => [:restaurant_id])
  end
end
