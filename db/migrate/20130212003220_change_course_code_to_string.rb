class ChangeCourseCodeToString < ActiveRecord::Migration
  def up
  	change_column :courses, :course_code, :string
  end

  def down
  	change_column :courses, :course_code, :integer
  end
end
