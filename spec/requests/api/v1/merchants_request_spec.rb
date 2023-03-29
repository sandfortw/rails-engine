# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(JSON.parse(response.body)['data'].count).to eq(3)
    expect(JSON.parse(response.body)['data']).to be_an Array
    expect(JSON.parse(response.body)['data'][0]['type']).to eq('merchant')
    expect(JSON.parse(response.body)['data'][0]['attributes']['name']).to be_a String
  end

  it 'can return a single Merchant' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"
    expect(response).to be_successful
    expect(JSON.parse(response.body)['data']).to be_a Hash
    expect(JSON.parse(response.body)['data']['type']).to eq('merchant')
    expect(JSON.parse(response.body)['data']['attributes']['name']).to be_a String
  end
end
