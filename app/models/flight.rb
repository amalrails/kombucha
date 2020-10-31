# frozen_string_literal: true

class Flight < ApplicationRecord
  has_many :kombuchas
  validate :validate_list
  before_save :set_name

  serialize :list, Array

  scope :random_order, -> { order("RANDOM()") }

  private

    def set_name
      self.name = "flight_#{Flight.maximum(:id).to_i.next}"
    end

    def validate_list
      errors.add(:list, "Kombucha Flight list size is not equal to 4") unless self.list.size.eql?(4)
      errors.add(:list, "Kombucha Flight List ids are not unique") unless self.list.uniq.eql?(self.list)
    end
end
