class Source < ApplicationRecord

  enum kind: [:paper, :book]

  belongs_to :user

  validates :title, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }
  default_scope { order(created_at: :desc) }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /pdf/

end
