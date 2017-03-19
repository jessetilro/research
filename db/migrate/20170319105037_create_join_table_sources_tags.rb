class CreateJoinTableSourcesTags < ActiveRecord::Migration[5.0]
  def change
    create_join_table :sources, :tags, table_name: :taggings do |t|
      t.index :source_id
      t.index :tag_id
    end
  end
end
