# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          search = params[:name]
          merchant = Merchant.find_one(search)
          if !merchant.blank?
            render json: MerchantSerializer.new(merchant)
          else
            render json: { data: {} }
          end
        end
      end
    end
  end
end
