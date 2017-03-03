class AddApprovalsCountToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :approvals_count, :integer, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE sources
           SET approvals_count = (SELECT count(1)
                                   FROM approvals
                                  WHERE approvals.source_id = sources.id)
    SQL
  end
end
