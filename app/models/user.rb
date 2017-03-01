class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sources
  has_many :approvals, dependent: :destroy

  def full_name
    last_name.present? ? "#{first_name} #{last_name}" : first_name
  end

end
