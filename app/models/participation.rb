class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
