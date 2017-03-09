class Source < ApplicationRecord

  include Referrable
  include BibtexMappable

  enum bibtex_type: [
    :article, :book, :booklet, :inbook, :incollection, :inproceedings, :manual, :mastersthesis, :misc, :phdthesis, :proceedings, :techreport, :unpublished
  ]

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :starrers, through: :stars, source: :user

  validates :title, presence: true
  validates :user, presence: true
  validates :bibtex_type, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }
  scope :sorted_by_stars_nonzero, ->(dir=:desc) { joins(:stars).group('sources.id').order('count(sources.id) desc') }
  scope :sorted_by_stars, ->(dir=:desc) { order(stars_count: dir) }
  scope :sorted_by_time, ->(dir=:desc) { order(created_at: dir) }
  scope :by_search_params, ->(params) {
    if [:time, :stars].include? params[:sort].try(:to_sym)
      unscoped.by_search_query(params[:q]).send "sorted_by_#{params[:sort]}"
    else
      by_search_query(params[:q])
    end
  }

  default_scope { sorted_by_time }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /pdf/

  # def self.bibtex_mapping; BIBTEX_MAPPING; end

  # Fix for nil mapping to default enum value
  def bibtex_type= value; super (value.nil? ? 0 : value); end

  def shortest_title; short_title || title; end

  def translated_bibtex_type
    I18n.t(bibtex_type, scope: 'activerecord.attributes.source.bibtex_types')
  end

  def starred_by? user
    !stars.by_user(user).empty?
  end

  def star_by user
    stars.by_user(user).first
  end

  def review_by user
    reviews.by_user(user).first
  end

end
