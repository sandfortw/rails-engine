# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          items = Item.where(merchant_id: params[:merchant_id])
          return render json: ErrorPoro.render_hash('No items found', 404).serialize, status: 404 if items.empty?

          render json: ItemSerializer.new(items)
        end
      end
    end
  end
end
