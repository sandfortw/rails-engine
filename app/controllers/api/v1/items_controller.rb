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
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render json: ErrorPoro.new('Bad Request', 400).serialize, status: :bad_request
        end
      end

      def update
        item = Item.find(params[:id])
        if item.update(item_params)
          render json: ItemSerializer.new(item), status: :accepted
        else
          render json: ErrorPoro.new('Bad Request', 400).serialize, status: :bad_request
        end
      end

      def destroy
        item = Item.find(params[:id])
        item.destroy
      end

      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
