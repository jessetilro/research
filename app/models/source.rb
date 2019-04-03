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

  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :user, presence: true

  scope :by_search_query, ->(q) {
    if q.present?
      terms = parse_query(q)
      sources = arel_table

      match = ->(col, q) { sources[col].lower.matches(q) }

      term_expressions = terms.map do |term|
        infix_term = "%#{term}%"

        fields = [:title, :abstract, :authors, :keywords]

        first_disjunct = match.call(fields.shift, infix_term)
        term_exp = fields.reduce(first_disjunct) { |exp, field| exp.or(match.call(field, infix_term)) }
        term_exp = term_exp.or(sources[:year].eq(term.to_i)) if (1900..(Date.today.year)).include?(term.to_i)
        term_exp = term_exp.or(sources[:doi].eq(term)) if doi_valid?(term)
        term_exp
      end

      expression = term_expressions.shift
      expression = term_expressions.reduce(expression) { |exp, conjunct| exp.and(conjunct) }

      where(expression)
        .order("levenshtein(lower(title), '#{q.downcase}')/CAST(char_length(title) AS FLOAT)")
    else
      all
    end
  }

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

  def self.select_average_rating
    reviews = Review.arel_table
    sources = Source.arel_table
    arel_average_rating = reviews.where(reviews[:source_id].eq(sources[:id]))
        .project(reviews[:rating].average)
    select(arel_average_rating.as('average_rating'))
  end

  def shortest_title; short_title || title; end

  def translated_bibtex_type(short: false)
    I18n.t(bibtex_type, scope: "activerecord.attributes.source.#{'short_' if short}bibtex_types")
  end

  def starred_by? user
    stars.select { |s| s.user == user  }.present?
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

  def compute_average_rating
    reviews.average :rating
  end

  def rating_by user
    reviews.find { |r| r.user_id == user.id }.try :rating
  end

  def list_starrers
    stars.map { |s| s.user.full_name }.join(', ')
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

  def self.parse_query(query)
    query.downcase.scan(/("[^"]+"|[^"\s]+)/).map do |term|
      if term.first.include?('"')
        [term.first.gsub(/"/, '')]
      else
        term.first.gsub(/[^\w\"]/, ' ').squish.split(' ')
      end
    end.flatten
  end

  def document_url; end
  def document_url=(document_url)
    return if document_url.blank?
    uri = URI.parse(document_url)
    filename = uri.path.split('/').last
    filename = 'document.pdf' if filename.blank?

    begin
      file = open(document_url)
    rescue Errno::ENOENT
      false
    else
      document.attach(io: file, filename: filename)
      true
    end
  end

  protected

  def infer_url_from_doi
    self.url = doi_url if url.blank?
  end
end
