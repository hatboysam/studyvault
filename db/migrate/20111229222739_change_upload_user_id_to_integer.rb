class ChangeUploadUserIdToInteger < ActiveRecord::Migration
  def self.up
    change_column :uploads, :user_id, :integer
  end

  def self.down
    change_column :uploads, :user_id, :string
  end
end
