# frozen_string_literal: true

class CreateKombuchas < ActiveRecord::Migration[5.1]
  def change
    create_table :kombuchas do |t|
      t.string :name
      t.string :fizziness_level

      t.timestamp
    end
  end
end
