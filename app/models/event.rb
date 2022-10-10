# frozen_string_literal: true

class Event < ApplicationRecord
  include Filterable
  include Sortable

  belongs_to :venue
  belongs_to :orchestra
end


