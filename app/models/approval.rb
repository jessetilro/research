class Approval < ApplicationRecord

  belongs_to :user
  belongs_to :source, counter_cache: true

  validates :source, presence: true
  validates :user, presence: true
  validates :source, uniqueness: { scope: :user }

  scope :by_user, ->(user) { where user: user }

end
