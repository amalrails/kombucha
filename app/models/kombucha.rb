# frozen_string_literal: true

class Kombucha < ApplicationRecord
  has_many :recipe_items
  has_many :ingredients, through: :recipe_items
  has_many :ratings

  validates :name, presence: true
  validates :fizziness_level, inclusion: { in: %w( high medium low ) }

  scope :filter_by_fizziness, -> (fizziness) { where fizziness_level: fizziness }
  scope :filter_by_vegan, -> (vegan) { includes(:ingredients).references(:ingredients)
                                       .where(ingredients: { vegan: vegan }) }
  scope :filter_by_caffeine_free, -> (caffeine) { includes(:ingredients).references(:ingredients)
                                                  .where(ingredients: { caffeine_free: caffeine }) }
  scope :with_different_tea_base, lambda do
    kombuchas = includes(:ingredients).references(:ingredients).where(ingredients: { base: true })
    base_hash = {}
    kombucha_ids_to_reject = []
    kombuchas.random_order.each do |kom|
      base_ingredient_id = kom.ingredients.where(base: true).first.id
      if base_hash.keys.include?(base_ingredient_id)
        kombucha_ids_to_reject << kom.id
      else
        base_hash[base_ingredient_id] = true
      end
    end
    kombuchas.reject_kombuchas(kombucha_ids_to_reject)
  end

  scope :reject_kombuchas, -> (ids) { where.not(id: ids) }
  scope :random_order, -> { order(Arel.sql("RANDOM()")) }
  scope :filter_by_recipe_name, -> (recipe_name) { where(name: recipe_name) }
  scope :filter_by_ingredient, -> (ingredient_name) {  includes(:ingredients)
                                                       .references(:ingredients)
                                                       .where(ingredients: { name: ingredient_name }) }
  scope :filter_by_avg_rating, -> (avg_rating) { includes(:ratings).references(:ratings)
                                                 .where('score > ?', avg_rating) }

  scope :filter_by_excluded_ingredient, -> (ex_ing_name) { includes(:ingredients)
                                                           .references(:ingredients)
                                                           .where
                                                           .not(ingredients: { name: ex_ing_name }) }


  def to_h
    {
      "id": self.id,
      "name": self.name,
      "fizziness_level": self.fizziness_level,
      "ingredients": self.ingredients.map(&:name)
    }
  end
end
