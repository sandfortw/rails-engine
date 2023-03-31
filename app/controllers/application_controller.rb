# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_response
  rescue_from NoMethodError, with: :error_response
  rescue_from StandardError, with: :error_response

  def error_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end
end
