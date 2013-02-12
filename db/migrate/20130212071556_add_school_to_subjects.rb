class AddSchoolToSubjects < ActiveRecord::Migration
  def change
  	add_column :subjects, :school_id, :integer
  end
end
