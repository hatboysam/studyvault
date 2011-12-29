class ChangeUploadUserIdToInteger < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :user_id
    add_column :uploads, :user_id, :integer
  end

  def self.down
     remove_column :uploads, :user_id
    add_column :uploads, :user_id, :string
  end
end
