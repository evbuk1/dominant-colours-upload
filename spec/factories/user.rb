# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:first_name) { |n| "fname-#{n}" }
    sequence(:last_name) { |n| "lname-#{n}" }
    sequence(:email) { |n| "factorybot-user-#{n}@songkick.com" }
    password { 'songkick_pw' }
  end
end
