module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

       def index
          item = Item.find(params[:item_id])
          merchant = Merchant.find(item.merchant_id)
          render json: ItemMerchantSerializer.new(merchant)
        end

        private
        def render_not_found
          render json: { error: "Item not found" }, status: :not_found
        end
      end
    end
  end
end
