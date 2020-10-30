# frozen_string_literal: true

FactoryBot.define do
  factory :kombucha do
    sequence(:name) { |n| "sample kombucha #{n}" }
    fizziness_level { "low" }

    trait :with_low_fizziness do
      fizziness_level { "low" }
    end

    trait :with_medium_fizziness do
      fizziness_level { "medium" }
    end

    trait :with_high_fizziness do
      fizziness_level { "high" }
    end
  end
end
