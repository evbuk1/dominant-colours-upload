# frozen_string_literal: true

FactoryBot.define do
  factory :location, class: 'Location' do
    sequence(:city) { |n| "city-#{n}" }
    sequence(:state) { |n| "state-#{n}" }
  end
end
