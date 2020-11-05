# frozen_string_literal: true

class AddIndexToRatings < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :score
  end
end
