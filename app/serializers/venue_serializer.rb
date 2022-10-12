# frozen_string_literal: true

class VenueSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :location

  attributes :name,
             :created_at,
             :updated_at

end
