# frozen_string_literal: true

FactoryBot.define do
  factory :artist, class: 'Artist' do
    sequence(:name) { |n| "artist-name-#{n}" }
    sequence(:website) { |n| "artist-website-#{n}" }
    sequence(:facebook) { |n| "artist-facebook-#{n}" }
    sequence(:twitter) { |n| "artist-twitter-#{n}" }
    genre { 'Pop' }
  end
end

