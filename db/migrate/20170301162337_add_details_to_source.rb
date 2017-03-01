class AddDetailsToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :search_query, :string
    add_column :sources, :search_database, :string
  end
end
