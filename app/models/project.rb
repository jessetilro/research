class Project < ApplicationRecord

  has_many :sources
  has_many :tags

  has_many :participations
  has_many :users, through: :participations

end
