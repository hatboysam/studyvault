class AddStarsRedeemedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :stars_redeemed, :integer, :default => 0
  end

  def self.down
    remove_column :users, :stars_redeemed
  end
end
