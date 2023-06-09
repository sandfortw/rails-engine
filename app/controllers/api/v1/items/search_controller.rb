# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if Item.find_all(params).nil? || invalid_search(params)
            render json: ErrorPoro.new('Bad Request', 400).serialize, status: :bad_request
          else
            render json: ItemSerializer.new(Item.find_all(params))
          end
        end

        def show
          item = Item.find_one(params)
          if invalid_search(params) || item.nil?
            render json: ErrorPoro.new('Bad Request', 400).cerealize, status: :bad_request
          else
            render json: ItemSerializer.new(item)
          end
        end

        private

        def invalid_search(params)
          both_name_and_price?(params) || any_price_negative?(params)
        end

        def both_name_and_price?(params)
          params[:name] && (params[:min_price] || params[:max_price])
        end

        def any_price_negative?(params)
          price_negative?(params[:min_price]) || price_negative?(params[:max_price])
        end

        def price_negative?(price)
          return !price.to_f.positive? if price.present?

          false
        end
      end
    end
  end
end
