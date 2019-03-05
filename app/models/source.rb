class Source < ApplicationRecord
  SCHOLAR_URL = "https://scholar.google.com/scholar?q=%{q}"
  DOI_URL = "https://doi.org/%{doi}"

  DOI_PATTERN = /^10.\d{4,9}\/[-._;()\/:A-Z0-9]+$/i

  include Referrable
  include BibtexMappable

  enum bibtex_type: [
    :article, :book, :booklet, :inbook, :incollection, :inproceedings, :manual, :mastersthesis, :misc, :phdthesis, :proceedings, :techreport, :unpublished
  ]

  belongs_to :user
  belongs_to :project
  has_many :reviews, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user
  has_many :starrers, through: :stars, source: :user
  has_and_belongs_to_many :tags, join_table: :taggings

  validates :title, presence: true
  validates :user, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }

  scope :sorted_by_stars_nocache, ->(dir=:desc) { left_outer_joins(:stars).group('sources.id').order("count(sources.id) #{dir == :asc ? :asc : :desc}") }
  scope :sorted_by_rating, ->(dir=:desc) { left_outer_joins(:reviews).group('sources.id').order("avg(reviews.rating) #{dir == :asc ? :asc : :desc}") }
  scope :sorted_by_stars, ->(dir=:desc) { order(stars_count: dir) }
  scope :sorted_by_time, ->(dir=:desc) { order(created_at: dir) }

  scope :filtered_by_unrated, ->(params={}) { left_outer_joins(:reviews).group('sources.id').having('count(reviews.rating) = 0') }
  scope :filtered_by_my_stars, ->(params={}) { joins(:stars).where(stars: {user_id: params[:u]}) }
  scope :filtered_by_my_reviews, ->(params={}) { left_outer_joins(:reviews).where(reviews: {user_id: params[:u]}) }

  scope :by_search_params, ->(params) {
    # Apply search query and sort
    result = unscoped.by_search_query(params[:q]).send "sorted_by_#{params[:s]}"
    # Filter by selected filter if applicable
    result = result.send "filtered_by_#{params[:f]}", params unless params[:f] == :none
    # Filter by tag if applicable
    result = result.joins(:tags).where(tags: {id: params[:t]}) if params[:t].present?

    result
  }

  scope :by_project, ->(project) { where(project: project) }

  default_scope { sorted_by_time }

  has_one_attached :document
  validates :document, file_content_type: {
    allow: ['application/pdf'],
    if: -> { document.attached? }
  }

  before_save :infer_url_from_doi

  def shortest_title; short_title || title; end

  def translated_bibtex_type(short: false)
    I18n.t(bibtex_type, scope: "activerecord.attributes.source.#{'short_' if short}bibtex_types")
  end

  def starred_by? user
    star_by(user).present?
  end

  def star_by user
    stars.find_by user: user
  end

  def reviewed_by? user
    review_by(user).present?
  end

  def review_by user
    reviews.find_by user: user
  end

  def average_rating
    reviews.average :rating
  end

  def rating_by user
    reviews.find_by(user_id: user.id).try :rating
  end

  def list_starrers
    starrers.map { |u| u.full_name }.join(', ')
  end

  def list_reviewers
    reviews.map { |r| "#{r.user.full_name} (#{r.rating})" }.join(', ')
  end

  def list_tags
    tags.map { |t| t.name }.join(', ')
  end

  def scholar_url
     SCHOLAR_URL % { q: CGI.escape("\"#{title}\"") }
  end

  def doi_url
    return if doi.blank? || !doi_valid?
    DOI_URL % { doi: doi }
  end

  def doi_valid?
    Source.doi_valid? doi
  end

  def self.doi_valid?(doi)
    return false if doi.blank?
    DOI_PATTERN.match?(doi)
  end

  protected

  def infer_url_from_doi
    self.url = doi_url if url.blank?
  end
end
