# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = Item.all
        render json: ItemSerializer.new(items)
      end

      def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item)
      end

      def create
        item = Item.create(item_params)
        render json: ItemSerializer.new(item), status: :created
      end


      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
