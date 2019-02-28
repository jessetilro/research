class RemovePaperclip < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :sources, :document_file_name
    remove_column :sources, :document_content_type
    remove_column :sources, :document_file_size
    remove_column :sources, :document_updated_at
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
