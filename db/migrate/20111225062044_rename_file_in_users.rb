class RenameFileInUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :files
    add_column :users, :numfiles, :integer
  end

  def self.down
    add_column :users, :files
    remove_column :users, :numfiles, :integer
  end
end
