# frozen_string_literal: true

class OrchestraSerializer
  include FastJsonapi::ObjectSerializer

  has_many :events

  attributes :name,
             :created_at,
             :updated_at

end
