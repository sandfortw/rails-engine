require 'rails_helper'

describe 'merchant items api' do
  
  before do 
    @merchant = create(:merchant)
  end

  it 'returns items for a merchant' do
    item1 = create(:item, merchant_id: @merchant.id)
    item2 = create(:item, merchant_id: @merchant.id)
    item3 = create(:item, merchant_id: @merchant.id)
    item4 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/merchants/#{@merchant.id}/items"

    expect(response).to be_successful
    expect(JSON.parse(response.body)['data']).to be_an Array
    expect(JSON.parse(response.body)['data'][0]['attributes']).to be_a Hash
    expect(JSON.parse(response.body)['data'][0]['attributes']['name']).to be_a String
    expect(JSON.parse(response.body)['data'][0]['attributes']['description']).to be_a String
    expect(JSON.parse(response.body)['data'][0]['attributes']['unit_price']).to be_a Numeric
    expect(JSON.parse(response.body)['data'][0]['attributes']['merchant_id']).to eq(@merchant.id)
  end

  it 'returns 404 if there are no items' do
    get "/api/v1/merchants/#{@merchant.id}/items"
    expect(response).to have_http_status(404)
  end
end