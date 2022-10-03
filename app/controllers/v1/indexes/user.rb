# frozen_string_literal: true

module V1
  module Indexes
    class User < Index
      SORTABLE_FIELDS = %i[first_name last_name email updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        first_name: [:contains],
        last_name: [:contains],
        email: [:contains],
        created_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end
