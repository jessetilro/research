class Source < ApplicationRecord

  enum kind: [:paper, :book]

  belongs_to :user

end
