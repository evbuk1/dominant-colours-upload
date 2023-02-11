# frozen_string_literal: true

class ImageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :elbow_plot,
             :image,
             :clustered_image,
             :rgb_colours,
             :hex_colours,
             :num_clusters,
             :created_at,
             :updated_at

end

