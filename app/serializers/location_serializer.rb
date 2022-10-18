# frozen_string_literal: true

class LocationSerializer
  include FastJsonapi::ObjectSerializer

  has_many :venues
  has_many :addresses

  attributes :ward,
             :borough,
             :created_at,
             :updated_at

end

