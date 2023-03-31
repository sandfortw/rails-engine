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
  describe 'creating a new item' do
    it 'can create an item' do
      new_item = create(:item, merchant_id: @merchant.id)
      post '/api/v1/items/', params: {
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

    it 'should not create a new item if it is invalid' do
      bad_item = create(:item, merchant_id: @merchant.id)
      post '/api/v1/items/', params: {
        "name": bad_item.name,
        "description": bad_item.description,
        "unit_price": bad_item.unit_price,
        "merchant_id": 'eleventy'
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data]).to be_an Array
      expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to be_an Array
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:status]).to eq(400)
    end
  end

  describe 'updating an item' do
    it 'can update an item' do
      put "/api/v1/items/#{@item1.id}", params: {
        "name": @item1.name,
        "description": 'A new description',
        "unit_price": @item1.unit_price,
        "merchant_id": @merchant.id
      }

      expect(response).to be_successful
      expect(JSON.parse(response.body)['data']).to be_a Hash
      expect(JSON.parse(response.body)['data']['type']).to eq('item')
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes]).to eq(
        { name: @item1.name,
          description: 'A new description',
          unit_price: @item1.unit_price,
          merchant_id: @merchant.id }
      )
    end

    it 'returns bad request error if item invalid' do
      put "/api/v1/items/#{@item1.id}", params: {
        "name": @item1.name,
        "description": 'A new description',
        "unit_price": 'a non numeric value',
        "merchant_id": @merchant.id
      }
      expect(response.status).to eq(400)
    end
  end

  describe 'delete' do
    it 'can delete an item' do
      expect(Item.all).to include(@item1)
      delete "/api/v1/items/#{@item1.id}"
      expect(Item.all).to_not include(@item1)
    end
  end
end
