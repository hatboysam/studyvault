class AddLimboCreditsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :limbo_credits, :integer, :default => 0
  end

  def self.down
    remove_column :users, :limbo_credits
  end
end
