class Review < ApplicationRecord

  belongs_to :source
  belongs_to :user

  validates :user, presence: true
  validates :source, presence: true
  validates :source, uniqueness: { scope: :user }

  scope :by_user, ->(user) { where user: user }

  def comment_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(comment.to_s).to_s
  end

end
