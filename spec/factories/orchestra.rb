# frozen_string_literal: true

FactoryBot.define do
  factory :orchestra, class: 'Orchestra' do
    sequence(:name) { |n| "orchestra-name-#{n}" }
  end
end

