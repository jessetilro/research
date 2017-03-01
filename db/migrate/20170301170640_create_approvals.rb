class CreateApprovals < ActiveRecord::Migration[5.0]
  def change
    create_table :approvals do |t|
      t.belongs_to :user, null: false
      t.belongs_to :source, null: false

      t.timestamps
    end
  end
end
