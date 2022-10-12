# frozen_string_literal: true

class EventSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :venue
  belongs_to :orchestra

  attributes :time,
             :type,
             :created_at,
             :updated_at

end

