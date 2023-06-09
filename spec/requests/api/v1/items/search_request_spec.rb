# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Request API', type: :request do
  before do
    @merchant = create(:merchant)
    @item_a = create(:item, name: 'AHello World', merchant_id: @merchant.id)
    @item_b = create(:item, name: 'bHello World', merchant_id: @merchant.id)
    @item_c = create(:item, name: 'cHello World', merchant_id: @merchant.id)
    @item_d = create(:item, name: 'dHello World', merchant_id: @merchant.id)
  end

  describe 'find_all' do
    context 'name only search, ?name=query' do
      context 'happy paths' do
        it 'should find all items by name fragment' do
          get '/api/v1/items/find_all?name=hello'

          expect(JSON.parse(response.body, symbolize_names: true)[:data].count).to eq(4)

          JSON.parse(response.body, symbolize_names: true)[:data].each do |item|
            expect(item[:attributes][:name]).to include('Hello World')
            expect(item[:attributes][:merchant_id]).to eq(@merchant.id)
          end
        end

        it 'should be case insensitive' do
          get '/api/v1/items/find_all?name=hELlo'
          expect(JSON.parse(response.body, symbolize_names: true)[:data].count).to eq(4)

          JSON.parse(response.body, symbolize_names: true)[:data].each do |item|
            expect(item[:attributes][:name]).to include('Hello World')
            expect(item[:attributes][:merchant_id]).to eq(@merchant.id)
          end
        end

        it 'should be in alphabetical order' do
          get '/api/v1/items/find_all?name=hello'
          items = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(items.sort_by { |i| i[:attributes][:name] }).to eq(items)
        end
      end

      context 'sad paths' do
        it 'should return 400 error code when name is searched with a price parameter' do
          get '/api/v1/items/find_all?name=hello&min_price=10'
          expect(response.status).to eq(400)

          get '/api/v1/items/find_all?name=hello&max_price=10'
          expect(response.status).to eq(400)
        end

        it 'should return a blank array of data when name is not found' do
          get '/api/v1/items/find_all?name=turing'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq([])
        end
      end
    end
  end

  describe '/items/find' do
    it 'can find an item' do
      get '/api/v1/items/find?name=hello'

      expect(JSON.parse(response.body, symbolize_names: true)[:data][:id]).to eq(@item_a.id.to_s)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:type]).to eq('item')
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes]).to eq({
                                                                                           name: @item_a.name,
                                                                                           description: @item_a.description,
                                                                                           unit_price: @item_a.unit_price,
                                                                                           merchant_id: @item_a.merchant_id
                                                                                         })
    end
    it 'NOMATCH' do
      get '/api/v1/items/find?name=NOMATCH'

      expect(JSON.parse(response.body,
                        symbolize_names: true)[:data]).to eq({ attributes: {}, id: nil, type: 'error' })
    end
  end
end
