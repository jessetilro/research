class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|

      t.string :title
      t.string :authors
      t.integer :year

      t.integer :kind
      t.string :url

      t.text :abstract
      t.text :description

      t.belongs_to :user, index: true

      t.timestamps

    end
  end
end
