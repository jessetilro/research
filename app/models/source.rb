class Source < ApplicationRecord

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
  validates :bibtex_type, presence: true

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

  def shortest_title; short_title || title; end

  def translated_bibtex_type
    I18n.t(bibtex_type, scope: 'activerecord.attributes.source.bibtex_types')
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

end
