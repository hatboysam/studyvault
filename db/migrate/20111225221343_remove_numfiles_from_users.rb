class RemoveNumfilesFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :numfiles
  end

  def self.down
    add_column :users, :numfiles, :integer
  end
end
