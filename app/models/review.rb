class Review < ApplicationRecord

  belongs_to :source
  belongs_to :user

  validates :user, presence: true
  validates :source, presence: true
  validates :source, uniqueness: { scope: :user }

  scope :by_user, ->(user) { where user: user }

end
