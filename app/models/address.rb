# frozen_string_literal: true

class Address < ApplicationRecord
  include Filterable
  include Sortable

  belongs_to :venue
end

