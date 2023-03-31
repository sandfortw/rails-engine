# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant Search Api', type: :request do
  before do
    @merchant = create(:merchant, name: 'Turing')
    @merchant_2 = create(:merchant, name: 'Ring World')
    @merchant_3 = create(:merchant, name: 'Spring')
  end

  describe 'GET /api/vi/items/find (find one)' do
    it 'should return the first object in the database in case insensitive alphabetical search' do
      get '/api/v1/merchants/find?name=ing'

      expect(response).to be_successful

      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq('Ring World')
    end

    it 'returns empty data object if no merchants are found' do
      get '/api/v1/merchants/find?name=123'

      expect(response).to be_successful
      expect(JSON.parse(response.body,
                        symbolize_names: true)).to eq({ data: { attributes: {}, id: nil, type: 'error' },
                                                        errors: [{ detail: 'Bad Request', status: 200,
                                                                   title: 'Bad Request' }] })
    end
  end

  describe '/api/v1/merchants/find_all?name=query' do
    it 'returns a json of all matching merchants' do
      get '/api/v1/merchants/find_all?name=ring'

      expect(response).to be_successful
      expect(JSON.parse(response.body, symbolize_names: true)[:data].count).to eq(3)
      expect(JSON.parse(response.body, symbolize_names: true)[:data].first[:attributes][:name]).to eq('Ring World')
      expect(JSON.parse(response.body, symbolize_names: true)[:data].last[:attributes][:name]).to eq('Turing')
    end

    describe 'sad paths' do
      it 'should return an empty array when there is no matching result' do
        get '/api/v1/merchants/find_all?name=douglas'
        expect(response).to be_successful
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq([])
      end

      it 'should return an empty array when there is a blank input' do
        get '/api/v1/merchants/find_all?name='
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body,
                          symbolize_names: true)[:data]).to eq([{ attributes: {}, id: nil, type: 'error' }])
      end
    end
  end
end
