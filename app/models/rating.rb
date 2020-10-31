# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :kombucha

  validates :score, presence: true
  validates :score, inclusion: 1..5
  validates_uniqueness_of :user_id, scope: [:kombucha_id]

  def attributes
    super.merge({ avg_rating: avg_rating })
  end

  def avg_rating
    ratings = Rating.where(kombucha_id: kombucha.id)
    ratings.sum(:score) / (ratings.count)
  end
end
