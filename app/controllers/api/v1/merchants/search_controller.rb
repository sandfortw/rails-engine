# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          merchants = Merchant.find_all(params[:name]) unless params[:name].blank?
          if !merchants.blank? 
            render json: MerchantSerializer.new(merchants)
          elsif merchants.nil?
            render json: { message: 'No Merchants Found', data: [] }, status: 400
          else
            render json: { message: 'No Merchants Found', data: [] }
          end
        end

        def show
          merchant = Merchant.find_one(params[:name]) unless params[:name].blank?
          if !merchant.blank? || params[:name].blank?
            render json: MerchantSerializer.new(merchant)
          elsif merchant.nil? && params[:name].blank?
            render json: { message: 'No Merchants Found', data: [] }, status: 400
          else
            render json: {detail: "No merchant found", :status=>200, data:{}}
          end
        end
      end
    end
  end
end
