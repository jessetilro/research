class Project < ApplicationRecord
  has_many :sources
  has_many :tags

  has_many :participations
  has_many :users, through: :participations

  validates :name, presence: true

  scope :ordered_by_last_usage, -> {
    order('participations.last_used_at DESC NULLS LAST')
  }

  def self.most_recently_used
    ordered_by_last_usage.first
  end
end
