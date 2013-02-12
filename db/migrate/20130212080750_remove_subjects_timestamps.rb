class RemoveSubjectsTimestamps < ActiveRecord::Migration
  def up
  	remove_column :subjects, :created_at
  	remove_column :subjects, :updated_at
  end

  def down
  	add_column :subjects, :created_at, :datetime
  	add_column :subjects, :updated_at, :datetime
  end
end
