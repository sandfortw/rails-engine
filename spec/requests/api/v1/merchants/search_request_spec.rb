# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant Search Api', type: :request do
  before do
    @merchant = create(:merchant, name: 'Turing')
    @merchant_2 = create(:merchant, name: 'Ring World')
  end
  describe 'GET /api/vi/items/find' do
    it 'should return the first object in the database in case insensitive alphabetical search' do
      get '/api/v1/merchants/find?name=ing'

      expect(response).to be_successful

      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq('Ring World')
    end

    it 'returns empty data object if no items are found' do
      get '/api/v1/merchants/find?name=123'

      expect(response).to be_successful
      expect(JSON.parse(response.body, symbolize_names: true)).to eq({ data: {} })
    end
  end
end
