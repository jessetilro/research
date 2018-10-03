class Project < ApplicationRecord

  has_many :sources
  has_many :tags

  has_many :participations
  has_many :users, through: :participations

  scope :ordered_by_last_usage, -> {
    order('participations.last_used_at DESC')
  }
end
