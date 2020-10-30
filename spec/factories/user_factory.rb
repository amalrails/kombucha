# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Fullscript Kombucha User #{n}" }
    email { Faker::Internet.email }
  end
end
