# frozen_string_literal: true

class ImageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :colour_pie,
             :image,
             :clustered_image,
             :rgb_colours,
             :hex_colours,
             :num_clusters,
             :created_at,
             :updated_at

end

