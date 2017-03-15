class Source < ApplicationRecord

  include Referrable
  include BibtexMappable

  enum bibtex_type: [
    :article, :book, :booklet, :inbook, :incollection, :inproceedings, :manual, :mastersthesis, :misc, :phdthesis, :proceedings, :techreport, :unpublished
  ]

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user
  has_many :starrers, through: :stars, source: :user

  validates :title, presence: true
  validates :user, presence: true
  validates :bibtex_type, presence: true

  scope :by_search_query, ->(q) { where('title LIKE ? OR abstract LIKE ? OR authors LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%") }

  scope :sorted_by_stars_nocache, ->(dir=:desc) { left_outer_joins(:stars).group('sources.id').order("count(sources.id) #{dir == :asc ? :asc : :desc}") }
  scope :sorted_by_rating, ->(dir=:desc) { left_outer_joins(:reviews).group('sources.id').order("avg(reviews.rating) #{dir == :asc ? :asc : :desc}") }
  scope :sorted_by_stars, ->(dir=:desc) { order(stars_count: dir) }
  scope :sorted_by_time, ->(dir=:desc) { order(created_at: dir) }

  scope :filtered_by_unrated, ->(params={}) { left_outer_joins(:reviews).group('sources.id').having('count(rating) = 0') }
  scope :filtered_by_my_stars, ->(params={}) { joins(:stars).where(stars: {user_id: params[:u]}) }
  scope :filtered_by_my_reviews, ->(params={}) { joins(:reviews).where(reviews: {user_id: params[:u]}) }

  scope :by_search_params, ->(params) {
    sorted = unscoped.by_search_query(params[:q]).send "sorted_by_#{params[:s]}"
    if params[:f] == :none
      sorted
    else
      sorted.send "filtered_by_#{params[:f]}", params
    end
  }

  default_scope { sorted_by_time }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /pdf/

  # Fix for nil mapping to default enum value
  def bibtex_type= value; super (value.nil? ? 0 : value); end

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

end
