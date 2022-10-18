# frozen_string_literal: true

module V1
  module Indexes
    class Artist < Index
      SORTABLE_FIELDS = %i[name genre facebook twitter website updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        name: [:contains],
        genre: [:contains],
        facebook: [:contains],
        twitter: [:contains],
        website: [:contains],
        created_at: %i[lt lte gt gte],
        updated_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end

