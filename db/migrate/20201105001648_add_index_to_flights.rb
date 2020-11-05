# frozen_string_literal: true

class AddIndexToFlights < ActiveRecord::Migration[5.2]
  def change
    add_index :flights, :name
    add_index :flights, :list
  end
end
