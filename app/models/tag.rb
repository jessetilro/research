class Tag < ApplicationRecord

  has_and_belongs_to_many :sources, join_table: :taggings

  validates :name, presence: true, uniqueness: true
  validates :color, presence: false, format: { with: /\A(?:#(?:[a-f0-9]{3}|[a-f0-9]{6})|)\z/, message: 'must be a valid hexadecimal color representation.' }

  def color= c
    super c.downcase
  end

  def effective_color
    color.present? ? color : '#333'
  end

end
