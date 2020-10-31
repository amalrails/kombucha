# frozen_string_literal: true

FactoryBot.define do
  factory :kombucha do
    sequence(:name) { |n| "sample kombucha #{n}" }
    fizziness_level { "low" }
    transient do
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
      ind = 0
      ingredients = build_list(:ingredient, 5) do |ingredient|
        ingredient.base = ind.eql?(1) ? true : false
        ind += 1
      end
      ind = 0
      kombucha.recipe_items = build_list(:recipe_item, 5) do |recipe|
        recipe.kombucha = kombucha
        recipe.ingredient = ingredients[ind]
        ind += 1
      end
    end
  end
end
