class AddDescriptionToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :description, :text
  end

  def self.down
    remove_column :responses, :description
  end
end
