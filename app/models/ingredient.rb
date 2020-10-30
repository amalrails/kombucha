# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipe_items
  has_many :kombuchas, through: :recipe_items

  validates :name, presence: true
  validates :base, inclusion: { in: [ true, false ] }
  validates :caffeine_free, inclusion: { in: [ true, false ] }
  validates :vegan, inclusion: { in: [ true, false ] }
end
