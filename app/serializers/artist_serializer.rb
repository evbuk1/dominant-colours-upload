# frozen_string_literal: true

class ArtistSerializer
  include FastJsonapi::ObjectSerializer

  has_many :events

  attributes :name,
             :website,
             :facebook,
             :twitter,
             :genre,
             :created_at,
             :updated_at

end
