# frozen_string_literal: true

module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def index
          item = Item.find(params[:item_id])
          merchant = Merchant.find(item.merchant_id)
          render json: ItemMerchantSerializer.new(merchant)
        end
      end
    end
  end
end
