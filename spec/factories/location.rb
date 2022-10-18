# frozen_string_literal: true

FactoryBot.define do
  factory :location, class: 'Location' do
    sequence(:ward) { |n| "ward-#{n}" }
    sequence(:borough) { |n| "borough-#{n}" }
  end
end
