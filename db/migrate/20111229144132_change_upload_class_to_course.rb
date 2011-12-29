class ChangeUploadClassToCourse < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :class_id
    add_column :uploads, :course_id, :integer
  end

  def self.down
    remove_column :uploads, :course_id
    add_column :uploads, :class_id, :integer
  end
end
