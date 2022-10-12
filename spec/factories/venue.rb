# frozen_string_literal: true

FactoryBot.define do
  factory :venue, class: 'Venue' do
    association :location
    sequence(:name) { |n| "venue-name-#{n}" }
  end
end
