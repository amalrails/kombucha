# frozen_string_literal: true

class Kombucha < ApplicationRecord
  has_many :recipe_items
  has_many :ingredients, through: :recipe_items

  validates :name, presence: true
  validates :fizziness_level, inclusion: { in: %w( high medium low ) }

  def to_h
    {
      "id": self.id,
      "name": self.name,
      "fizziness_level": self.fizziness_level,
      "ingredients": self.ingredients.map(&:name)
    }
  end
end
