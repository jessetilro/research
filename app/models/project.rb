class Project < ApplicationRecord

  has_many :sources
  has_many :tags

  has_and_belongs_to_many :users, join_table: :participations

end
