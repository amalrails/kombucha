# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.boolean :base
      t.boolean :caffeine_free
      t.boolean :vegan

      t.timestamps
    end
  end
end
