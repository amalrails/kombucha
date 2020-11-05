# frozen_string_literal: true

class AddIndexToIngredients < ActiveRecord::Migration[5.2]
  def change
    add_index :ingredients, :name
    add_index :ingredients, :base
    add_index :ingredients, :caffeine_free
    add_index :ingredients, :vegan
  end
end
