class AddSwagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :swag, :integer, :default => 100
  end

  def self.down
    remove_column :users, :swag
  end
end
