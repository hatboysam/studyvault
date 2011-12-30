class AddTempCoursenameToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :temp_coursename, :string
  end

  def self.down
    remove_column :uploads, :temp_coursename
  end
end
