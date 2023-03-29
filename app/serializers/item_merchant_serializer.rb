# frozen_string_literal: true

class ItemMerchantSerializer
  include JSONAPI::Serializer
  set_type :merchant
  attributes :name
end
