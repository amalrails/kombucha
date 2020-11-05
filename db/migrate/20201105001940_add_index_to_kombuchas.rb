# frozen_string_literal: true

class AddIndexToKombuchas < ActiveRecord::Migration[5.2]
  def change
    add_index :kombuchas, :name
    add_index :kombuchas, :fizziness_level
  end
end
