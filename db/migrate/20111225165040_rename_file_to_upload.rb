class RenameFileToUpload < ActiveRecord::Migration
  def self.up
    rename_table :files, :uploads
  end

  def self.down
    rename_table :uploads, :files
  end
end
