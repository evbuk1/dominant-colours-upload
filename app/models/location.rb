# frozen_string_literal: true

class Location < ApplicationRecord
  include Filterable
  include Sortable

  has_many :venues
end
