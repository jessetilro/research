class AddBibtexFieldsToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :bibtex_key, :string
    add_column :sources, :isbn, :string
    add_column :sources, :doi, :string
    add_column :sources, :editors, :text
    add_column :sources, :subtitle, :string
    add_column :sources, :shorttitle, :string
    add_column :sources, :month, :integer
    add_column :sources, :publisher, :string
    add_column :sources, :institution, :string
    add_column :sources, :organization, :string
    add_column :sources, :address, :text
    add_column :sources, :school, :string
    add_column :sources, :edition, :string
    add_column :sources, :series, :string
    add_column :sources, :chapter, :integer
    add_column :sources, :pages, :string
    add_column :sources, :journal, :string
    add_column :sources, :number, :integer
    add_column :sources, :volume, :integer
    add_column :sources, :note, :text

    reversible do |dir|
      dir.up do
        remove_column :sources, :description
      end
      dir.down do
        add_column :sources, :description, :text
      end
    end
  end
end
