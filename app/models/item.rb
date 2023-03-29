# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, presence: true
  validates_numericality_of :unit_price, :merchant_id
end
