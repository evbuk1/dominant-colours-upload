# frozen_string_literal: true

class Venue < ApplicationRecord
  include Filterable
  include Sortable

  belongs_to :location
  has_many :events
end
