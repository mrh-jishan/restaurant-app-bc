module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::RoutingError do |e|
      if %w(staging development).include? ENV['RAILS_ENV']
        json_response({message: e.message, error: e, stacktrace: e.backtrace.join("\n")}, :not_found)
      else
        json_response({message: e.message, error: e}, :not_found)
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      if %w(staging development).include? ENV['RAILS_ENV']
        json_response({message: e.message, error: e, stacktrace: e.backtrace.join("\n")}, :not_found)
      else
        json_response({message: e.message, error: e}, :not_found)
      end
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      if %w(staging development).include? ENV['RAILS_ENV']
        json_response({message: e.message, error: e, stacktrace: e.backtrace.join("\n")}, :unprocessable_entity)
      else
        json_response({message: e.message, error: e}, :unprocessable_entity)
      end
    end

    rescue_from Exception do |e|
      if %w(staging development).include? ENV['RAILS_ENV']
        json_response({message: e.message, error: e, stacktrace: e.backtrace.join("\n")}, :bad_request)
      else
        json_response({message: e.message, error: e}, :bad_request)
      end
    end
  end
end