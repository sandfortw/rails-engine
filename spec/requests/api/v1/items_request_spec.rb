# frozen_string_literal: true

require 'rails_helper'

describe 'items api' do
  before do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)
    @item3 = create(:item, merchant_id: @merchant.id)
    @item4 = create(:item, merchant_id: @merchant.id)
  end

  it 'can return many items' do
    get '/api/v1/items'

    expect(response).to be_successful
    expect(JSON.parse(response.body)).to be_a Hash
    expect(JSON.parse(response.body)['data']).to be_an Array
    expect(JSON.parse(response.body)['data'].count).to eq(4)
    expect(JSON.parse(response.body)['data'].first.keys).to contain_exactly('id', 'type', 'attributes')

    expect(JSON.parse(response.body)['data'].first['id']).to eq(@item1.id.to_s)

    expect(JSON.parse(response.body)['data'].first['type']).to be_a String
    expect(JSON.parse(response.body)['data'].first['type']).to eq('item')

    expect(JSON.parse(response.body)['data'].first['attributes']).to be_a Hash
    expect(JSON.parse(response.body)['data'].first['attributes'].keys).to contain_exactly('name', 'description',
                                                                                          'unit_price', 'merchant_id')

    expect(JSON.parse(response.body, symbolize_names: true)[:data].first[:attributes]).to eq(
      { name: @item1.name,
        description: @item1.description,
        unit_price: @item1.unit_price,
        merchant_id: @merchant.id }
    )
  end

  it 'can return one item' do
    get "/api/v1/items/#{@item4.id}"

    expect(response).to be_successful
    expect(JSON.parse(response.body)['data']).to be_a Hash
    expect(JSON.parse(response.body)['data']['id']).to eq(@item4.id.to_s)
    expect(JSON.parse(response.body)['data']['type']).to eq('item')
    expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes]).to eq(
      { name: @item4.name,
        description: @item4.description,
        unit_price: @item4.unit_price,
        merchant_id: @merchant.id }
    )
    end

  it 'can create an item' do
    new_item = create(:item, merchant_id: @merchant.id)
    post "/api/v1/items/", params: {
      "name": new_item.name,
      "description": new_item.description,
      "unit_price": new_item.unit_price,
      "merchant_id": @merchant.id
    }

    expect(response).to be_successful
    expect(JSON.parse(response.body)['data']).to be_a Hash
    expect(JSON.parse(response.body)['data']['type']).to eq('item')
    expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes]).to eq(
      { name: new_item.name,
        description: new_item.description,
        unit_price: new_item.unit_price,
        merchant_id: @merchant.id }
    )
  end

  it 'can update an item' do
  end

  it 'can delete an item' do
  end
end
