class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    items = Item.where(merchant_id: params[:merchant_id])
    return render status: :not_found if items.empty?
    render json: ItemSerializer.new(items)
  end

end