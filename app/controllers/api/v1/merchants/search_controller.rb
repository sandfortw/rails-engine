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
            render json: ErrorPoro.new('Bad Request', 400).serialize, status: :bad_request
          else
            render json: MerchantSerializer.new(merchants)
          end
        end

        def show
          merchant = Merchant.find_one(params[:name]) unless params[:name].blank?
          if !merchant.blank? || params[:name].blank?
            render json: MerchantSerializer.new(merchant)
          elsif merchant.nil? && params[:name].blank?
            render json: ErrorPoro.new('Bad Request', 400).serialize, status: :bad_request
          else
            render json: ErrorPoro.new('Bad Request', 200).cerealize, status: :ok
          end
        end
      end
    end
  end
end
