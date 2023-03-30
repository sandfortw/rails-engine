# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, presence: true
  validates_numericality_of :unit_price, :merchant_id

  def self.find_all(params)
    if params[:name]
      find_by_name(params)
    else
      find_by_price(params)
    end
  end

  def self.find_one(params) 
    if params[:name]
      find_by_name(params).first
    else
      find_by_price(params).first
    end
  end

  # Private Methods (rubocop does not like 'useless' private access modifier)
  def self.find_by_price(params)
    min = params[:min_price] || 0
    max = params[:max_price] || 100_000_000
    where("items.unit_price >= #{min} and items.unit_price <= #{max}")
      .order('LOWER(name)')
  end

  def self.find_by_name(params)
    where('items.name ILIKE ?', "%#{params[:name]}%")
      .order('LOWER(name)')
  end
end
