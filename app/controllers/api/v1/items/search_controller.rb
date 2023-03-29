# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if invalid_search(params)
            render json: { data: [], errors: 'Bad Request'}, status: :bad_request
          else
            render json: ItemSerializer.new(Item.find_all(params))
          end
        end

        private

        def invalid_search(params)
          (params[:name] && (params[:min_price] || params[:max_price])) || 
          (params[:min_price] && params[:min_price].to_i < 0) || 
          (params[:max_price] && params[:max_price].to_i < 0)
        end
      end
    end
  end
end
