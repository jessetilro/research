class Review < ApplicationRecord

  belongs_to :source
  belongs_to :user

  validates :user, presence: true
  validates :source, presence: true
  validates :source, uniqueness: { scope: :user }
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def comment_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(comment.to_s).to_s
  end

end
