class Source < ApplicationRecord

  enum kind: [
    :paper, :book, :edited, :conference, :journal
  ]

  belongs_to :user
  has_many :approvals, dependent: :destroy
  has_many :approvers, through: :approvals, source: :user

  validates :title, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }
  default_scope { order(created_at: :desc) }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /pdf/

  def translated_kind
    I18n.t(kind, scope: 'activerecord.attributes.source.kinds')
  end

  def approved_by? user
    !approvals.by_user(user).empty?
  end

  def approval_by user
    approvals.by_user(user).first
  end

end
