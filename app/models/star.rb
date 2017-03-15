class Star < ApplicationRecord

  belongs_to :user
  belongs_to :source, counter_cache: true

  validates :source, presence: true
  validates :user, presence: true
  validates :source, uniqueness: { scope: :user }

end
