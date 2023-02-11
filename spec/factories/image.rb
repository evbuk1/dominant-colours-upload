# frozen_string_literal: true

FactoryBot.define do
  factory :image, class: 'Image' do
    sequence(:elbow_plot) { |n| "elbow-plot-path-#{n}" }
    sequence(:image) { |n| "image-path-#{n}" }
    sequence(:clustered_image) { |n| "clustered-image-path-#{n}" }
    rgb_colours { "[100, 200, 300]" }
    hex_colours { "#FFFFFF #000000 #E6FFHH"}
    num_clusters { 5 }
  end
end

