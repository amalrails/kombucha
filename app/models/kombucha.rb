# frozen_string_literal: true

class Kombucha < ApplicationRecord
  has_many :recipe_items
  has_many :ingredients, through: :recipe_items

  validates :name, presence: true
  validates :fizziness_level, inclusion: { in: %w( high medium low ) }

  scope :filter_by_fizziness, -> (fizziness) { where fizziness_level: fizziness }
  scope :filter_by_vegan, -> (vegan) { includes(:ingredients)
                                       .where(ingredients: { vegan: vegan }) }
  scope :filter_by_caffeine_free, -> (caffeine) { includes(:ingredients)
                                                  .where(ingredients: { vegan: caffeine }) }

  def to_h
    {
      "id": self.id,
      "name": self.name,
      "fizziness_level": self.fizziness_level,
      "ingredients": self.ingredients.map(&:name)
    }
  end
end
