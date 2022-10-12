# frozen_string_literal: true

module V1
  module Indexes
    class Event < Index
      SORTABLE_FIELDS = %i[time type updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        time: %i[lt lte gt gte],
        type: [:contains],
        created_at: %i[lt lte gt gte],
        updated_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end


