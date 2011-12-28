class RenameClasses < ActiveRecord::Migration
  def self.up
    rename_table :classes, :courses
  end

  def self.down
    rename_table :courses, :classes
  end
end
