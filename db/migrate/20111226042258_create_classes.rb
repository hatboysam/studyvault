class CreateClasses < ActiveRecord::Migration
  def self.up
    create_table :classes do |t|
      t.string  :subject
      t.integer :course_code
      
      t.integer :school_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :classes
  end
end
