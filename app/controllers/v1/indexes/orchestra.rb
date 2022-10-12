# frozen_string_literal: true

module V1
  module Indexes
    class Orchestra < Index
      SORTABLE_FIELDS = %i[name updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        name: [:contains],
        created_at: %i[lt lte gt gte],
        updated_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end

