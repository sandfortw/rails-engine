# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe '.find_one(search_string)' do
    before do 
      @merchant = create(:merchant, name: 'Turing')
      @merchant2 = create(:merchant, name: 'Ring World')
    end
    it 'can search parts of names' do
      expect(Merchant.find_one('ing')).to eq(@merchant2)
    end

    it 'does not care about capitalization' do
      expect(Merchant.find_one('INg')).to eq(@merchant2)
    end

    it 'returns the first alphabetical result' do
      merchant3 = create(:merchant, name: 'inging')
      expect(Merchant.find_one('INg')).to eq(merchant3)
    end
  end
end
