class Source < ApplicationRecord

  enum bibtex_type: [
    :article, :book, :booklet, :inbook, :incollection, :inproceedings, :manual, :mastersthesis, :misc, :phdthesis, :proceedings, :techreport, :unpublished
  ]

  belongs_to :user
  has_many :approvals, dependent: :destroy
  has_many :approvers, through: :approvals, source: :user

  validates :title, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }
  scope :sorted_by_approvals_nonzero, ->(dir=:desc) { joins(:approvals).group('sources.id').order('count(sources.id) desc') }
  scope :sorted_by_approvals, ->(dir=:desc) { order(approvals_count: dir) }
  scope :sorted_by_time, ->(dir=:desc) { order(created_at: dir) }
  scope :by_search_params, ->(params) {
    if [:time, :approvals].include? params[:sort].try(:to_sym)
      unscoped.by_search_query(params[:q]).send "sorted_by_#{params[:sort]}"
    else
      by_search_query(params[:q])
    end
  }

  default_scope { sorted_by_time }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /pdf/

  def translated_bibtex_type
    I18n.t(bibtex_type, scope: 'activerecord.attributes.source.bibtex_types')
  end

  def approved_by? user
    !approvals.by_user(user).empty?
  end

  def approval_by user
    approvals.by_user(user).first
  end

end
