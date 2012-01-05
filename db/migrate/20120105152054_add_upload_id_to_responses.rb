class AddUploadIdToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :upload_id, :integer
  end

  def self.down
    remove_column :responses, :upload_id
  end
end
