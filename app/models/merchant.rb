# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  def self.find_one(search_string)
    where('merchants.name ILIKE ?', "%#{search_string}%")
      .order('LOWER(name)')
      .first
  end
end
