
# frozen_string_literal: true

module V1
  module Indexes
    class Image < Index
      SORTABLE_FIELDS = %i[elbow_plot image clustered_image rgb_colours hex_colours num_clusters updated_at created_at].freeze
      FILTERABLE_FIELDS = [
        elbow_plot: [:contains],
        image: [:contains],
        clustered_image: [:contains],
        rgb_colours: [:contains],
        hex_colours: [:contains],
        num_clusters: %i[lt lte gt gte],
        created_at: %i[lt lte gt gte],
        updated_at: %i[lt lte gt gte]
      ].freeze
      INCLUDES = %i[].freeze
    end
  end
end