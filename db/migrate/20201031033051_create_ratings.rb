# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.decimal :score
      t.references :kombucha
      t.references :user
      t.timestamps
    end
  end
end
