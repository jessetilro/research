class UpdateSourceStringToTextColumns < ActiveRecord::Migration[5.0]
  def up
    change_column :sources, :search_query, :text
    change_column :sources, :keywords, :text
    change_column :sources, :url, :text
    change_column :sources, :authors, :text
  end

  def down
    change_column :sources, :search_query, :string
    change_column :sources, :keywords, :string
    change_column :sources, :url, :string
    change_column :sources, :authors, :string
  end
end
