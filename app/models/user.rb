class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sources
  has_many :stars, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_and_belongs_to_many :projects, join_table: :participations

  enum role: [:contributor, :supervisor]

  scope :contributors, ->() { where(role: :contributor) }
  scope :supervisors, ->() { where(role: :supervisor) }

  def full_name
    last_name.present? ? "#{first_name} #{last_name}" : first_name
  end

end
