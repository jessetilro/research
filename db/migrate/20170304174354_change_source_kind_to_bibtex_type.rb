class ChangeSourceKindToBibtexType < ActiveRecord::Migration[5.0]
  def change
    # Add bibtex_type replacing kind
    add_column :sources, :bibtex_type, :integer, default: 0

    # Map kinds to bibtex_types.
    # (warning: no bijective mapping, so not perfectly reversible).
    reversible do |dir|
      dir.up do
        Source.where(kind: [0,3]).update_all(bibtex_type: 5)
        Source.where(kind: 1).update_all(bibtex_type: 1)
        Source.where(kind: 2).update_all(bibtex_type: 4)
        Source.where(kind: 4).update_all(bibtex_type: 0)
        Source.where(kind: 5).update_all(bibtex_type: 11)
      end
      dir.down do
        Source.where(bibtex_type: 5).update_all(kind: 3)
        Source.where(bibtex_type: 1).update_all(kind: 1)
        Source.where(bibtex_type: 4).update_all(kind: 2)
        Source.where(bibtex_type: 0).update_all(kind: 4)
        Source.where(bibtex_type: 11).update_all(kind: 5)
      end
    end

    # Remove now unused kinds
    reversible do |dir|
      dir.up do
        remove_column :sources, :kind
      end
      dir.down do
        add_column :sources, :kind, :integer, default: 0
      end
    end
  end
end
