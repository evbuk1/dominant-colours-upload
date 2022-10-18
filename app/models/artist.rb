# frozen_string_literal: true

class Artist < ApplicationRecord
  include Filterable
  include Sortable

  has_many :events
end
