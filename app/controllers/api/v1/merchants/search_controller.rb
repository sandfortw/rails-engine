# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          merchants = Merchant.find_all(params[:name])
          if !merchants.blank?
            render json: MerchantSerializer.new(merchants)
          else
            render json: { message: 'No Merchants Found', data: [] }
          end
        end

        def show
          merchant = Merchant.find_one(params[:name])
          if !merchant.blank?
            render json: MerchantSerializer.new(merchant)
          else
            render json: ErrorPoro.new('No merchant found', 200).serialize
          end
        end
      end
    end
  end
end
