class AddDownloadEmailColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_download_email, :datetime
    add_column :users, :downloads_since_email, :integer
  end

  def self.down
    remove_column :users, :last_download_email
    remove_column :users, :downloads_since_email
  end
end
