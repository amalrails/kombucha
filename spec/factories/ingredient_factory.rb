# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient, class: Ingredient do
    sequence(:name) { |n| "sample ingredient #{n}" }
    base { true }
    caffeine_free { false }
    vegan { false }

    trait :caffeine_free do
      caffeine_free { true }
    end

    trait :vegan do
      vegan { true }
    end
  end
end
