# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  before do
    @merchant = create(:merchant, name: 'Turing')
    @merchant2 = create(:merchant, name: 'Ring World')
  end

  describe '.find_one(search_string)' do
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

  describe '.find_all(search_string)' do
    it 'can search parts of names' do
      expect(Merchant.find_all('ing')).to contain_exactly(@merchant, @merchant2)
    end

    it 'does not care about capitalization' do
      expect(Merchant.find_all('INg')).to contain_exactly(@merchant, @merchant2)
    end

    it 'returns the first alphabetical result' do
      merchant3 = create(:merchant, name: 'inging')
      expect(Merchant.find_all('INg')).to eq([merchant3, @merchant2, @merchant])
    end
  end
end
