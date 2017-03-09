class RenameApprovalsToStars < ActiveRecord::Migration[5.0]
  def change
    rename_table :approvals, :stars
    rename_column :sources, :approvals_count, :stars_count
  end
end
