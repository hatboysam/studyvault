class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string    :temp_coursename
      t.string    :professor
      t.string    :semester
      
      t.datetime  :year
      
      t.integer   :course_id
      t.integer   :school_id
      t.integer   :user_id
      
      t.text      :description
      
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
