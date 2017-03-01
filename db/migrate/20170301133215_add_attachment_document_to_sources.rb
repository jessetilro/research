class AddAttachmentDocumentToSources < ActiveRecord::Migration
  def self.up
    change_table :sources do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :sources, :document
  end
end
