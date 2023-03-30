# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_numericality_of :unit_price }
    it { should validate_numericality_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end

  before do
    @merchant = create(:merchant)
    @item1 = create(:item, name: 'Aturing', unit_price: 1.00, merchant_id: @merchant.id)
    @item2 = create(:item, name: 'Bturing', unit_price: 5.00, merchant_id: @merchant.id)
    @item3 = create(:item, name: 'Cturing', unit_price: 10.00, merchant_id: @merchant.id)
    @item4 = create(:item, name: 'Dturing', unit_price: 15.00, merchant_id: @merchant.id)
    @item5 = create(:item, name: 'Eturing', unit_price: 20.01, merchant_id: @merchant.id)
    @item6 = create(:item, name: 'aaturing', unit_price: 20.02, merchant_id: @merchant.id)
  end
  describe 'find_all items (ordered alphabetically)' do
    it 'can find all items by name' do
      params = { name: 'Bturing' }
      expect(Item.find_all(params)).to eq([@item2])
    end

    it 'can find all items by name fragment' do
      params = { name: 'turing' }
      expect(Item.find_all(params)).to eq([@item6, @item1, @item2, @item3, @item4, @item5])
    end

    it 'can find all items above a certain price' do
      params = { min_price: 10.00 }
      expect(Item.find_all(params)).to eq([@item6, @item3, @item4, @item5])
    end

    it 'can find all items below a certain price' do
      params = { max_price: 10.00 }
      expect(Item.find_all(params)).to eq([@item1, @item2, @item3])
    end

    it 'can find by combo of low and high price' do
      params = { max_price: 10.00, min_price: 5 }
      expect(Item.find_all(params)).to eq([@item2, @item3])
    end
  end

  describe 'find_one (first alphabetical)' do
    it 'can find one item by name' do
      params = { name: 'Cturing' }
      expect(Item.find_one(params)).to eq(@item3)
    end

    it 'can find one item by name fragment' do
      params = { name: 'turing' }
      expect(Item.find_one(params)).to eq(@item6)
    end

    it 'can find one item above a certain price' do
      params = { min_price: 10.00 }
      expect(Item.find_one(params)).to eq(@item6)
    end

    it 'can find one item below a certain price' do
      params = { max_price: 5.00 }
      expect(Item.find_one(params)).to eq(@item1)
    end

    it 'can find by combo low and high price' do
      params = { min_price: 10.00, max_price: 15.00 }
      expect(Item.find_one(params)).to eq(@item3)
    end
  end
end
