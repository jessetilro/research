class AddKeywordsToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :keywords, :string
  end
end
