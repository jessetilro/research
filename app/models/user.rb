class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :sources
  has_many :stars, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :participations
  has_many :projects, through: :participations

  has_many :accessible_sources, through: :projects, source: :sources
  has_many :accessible_tags, through: :projects, source: :tags

  enum role: [:contributor, :supervisor]

  scope :contributors, ->() { where(role: :contributor) }
  scope :supervisors, ->() { where(role: :supervisor) }

  def full_name
    return email if first_name.blank?
    last_name.present? ? "#{first_name} #{last_name}" : first_name
  end

  def salutation
    first_name.present? ? first_name : 'there'
  end
end
