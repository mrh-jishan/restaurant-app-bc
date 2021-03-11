module ResponseHelper
  def json_response(object, status = 200, message = {} )
    render json: {
        :data => object,
        :success => (status == 200 || status == 201),
        :message => message,
        :code => status,
        :time => Time.now.utc
    }, status: status
  end

  def resource_validation_error(resource)
    json_response({errors: resource.errors}, 422, resource.errors.full_messages.join(', '))
  end
end