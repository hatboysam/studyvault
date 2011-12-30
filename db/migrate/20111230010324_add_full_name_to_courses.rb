class AddFullNameToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :full_name, :string
  end

  def self.down
    remove_column :courses, :full_name
  end
end
