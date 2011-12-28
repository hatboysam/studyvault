class AddDesrciptionToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :description, :text, :default => "No description given"
  end

  def self.down
    remove_column :uploads, :description
  end
end
