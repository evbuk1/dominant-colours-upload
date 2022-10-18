# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: 'Event' do
    association :venue
    association :artist
    event_time { Time.now }
    event_type { 'Regular season' }
  end
end

