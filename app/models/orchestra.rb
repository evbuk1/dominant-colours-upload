# frozen_string_literal: true

class Orchestra < ApplicationRecord
  include Filterable
  include Sortable

  has_many :events
end
