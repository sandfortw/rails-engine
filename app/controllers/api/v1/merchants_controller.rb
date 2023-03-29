# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        merchants = Merchant.all
        render json: MerchantSerializer.new(merchants)
      end

      def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
      end

      def find
        search = params[:name]
        merchant = Merchant.where("merchants.name ILIKE ?", "%#{search}%").first
        if !merchant.blank?
          render json: MerchantSerializer.new(merchant)
        else
          render json: {data: {}}
        end
      end
    end
  end
end
