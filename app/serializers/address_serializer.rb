# frozen_string_literal: true

class AddressSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :venue

  attributes :address1,
             :address2,
             :address3,
             :created_at,
             :updated_at

end

