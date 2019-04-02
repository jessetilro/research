class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  scope :ordered_by_last_usage, -> {
    order('last_used_at DESC NULLS LAST')
  }
end
