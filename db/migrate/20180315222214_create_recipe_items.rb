# frozen_string_literal: true

class CreateRecipeItems < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_items do |t|
      t.references :kombucha
      t.references :ingredient

      t.integer :amount
    end
  end
end
