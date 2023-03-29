# frozen_string_literal: true

require 'rails_helper'

describe 'Item\'s merchant API' do
  before do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant_id: @merchant.id)
  end

  it 'should get the merchant for an item' do
    get "/api/v1/items/#{@item1.id}/merchant"

    expect(response).to be_successful
    expect(JSON.parse(response.body)).to eq({ 'data' => { 'attributes' => { 'name' => @merchant.name.to_s },
                                                          'id' => @merchant.id.to_s, 'type' => 'merchant' } })
  end

  it 'should return 404 if the item does not exist' do
    get '/api/v1/items/non_number/merchant'

    expect(response).to have_http_status(404)
  end
end
