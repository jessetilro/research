# inspired by https://github.com/thoughtbot/paperclip/blob/master/MIGRATING.md

class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      source_by_blob_key = {}

      blobs = []
      Source.all.each do |src|
        next if src.document.path.blank?

        key = SecureRandom.uuid

        blobs << {
          key: key,
          filename: src.document_file_name,
          content_type: src.document_content_type,
          metadata: '{}',
          byte_size: src.document_file_size,
          checksum: Digest::MD5.base64digest(File.read(src.document.path)),
          created_at: src.updated_at.iso8601
        }

        source_by_blob_key[key] = src
      end

      ActiveStorage::Blob.import(blobs, validate: false)

      attachments = []
      ActiveStorage::Blob.all.each do |blob|
        src = source_by_blob_key[blob.key]

        attachments << {
          name: 'document',
          record_type: 'Source',
          record_id: src.id,
          blob_id: blob.id,
          created_at: src.updated_at.iso8601
        }
      end

      ActiveStorage::Attachment.import(attachments, validate: false)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
