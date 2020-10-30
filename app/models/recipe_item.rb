# frozen_string_literal: true

class RecipeItem < ApplicationRecord
  belongs_to :ingredient
  belongs_to :kombucha
end
