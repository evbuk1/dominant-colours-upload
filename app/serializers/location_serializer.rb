# frozen_string_literal: true

class LocationSerializer
  include FastJsonapi::ObjectSerializer

  has_many :venues

  attributes :city,
             :state,
             :created_at,
             :updated_at

end

