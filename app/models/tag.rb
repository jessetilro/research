class Tag < ApplicationRecord

  has_and_belongs_to_many :sources, join_table: :taggings

  validates :name, presence: true, uniqueness: true

end
