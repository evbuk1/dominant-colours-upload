# frozen_string_literal: true

module V1
  module Indexes
    class Location < Index
      SORTABLE_FIELDS = %i[city state updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        city: [:contains],
        state: [:contains],
        created_at: %i[lt lte gt gte],
        updated_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end
