# frozen_string_literal: true

FactoryBot.define do
  factory :kombucha do
    sequence(:name) { |n| "sample kombucha #{n}" }
    fizziness_level { "low" }
    transient do
      ingredient_name { Faker::Food.ingredient }
      vegan { false }
      caffeine_free { false }
    end

    trait :with_low_fizziness do
      fizziness_level { "low" }
    end

    trait :with_medium_fizziness do
      fizziness_level { "medium" }
    end

    trait :with_high_fizziness do
      fizziness_level { "high" }
    end

    after(:build) do |kombucha, evaluator|
      kombucha.ingredients = build_list(:ingredient, 3, name: evaluator.ingredient_name,
                                        vegan: evaluator.vegan,
                                        caffeine_free: evaluator.caffeine_free)
    end
  end
end
