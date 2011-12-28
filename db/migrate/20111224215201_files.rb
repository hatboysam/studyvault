class Files < ActiveRecord::Migration
  def self.up
    create_table :files do |t|
      t.string :user_id
      
      #begin Paperclip Columns
      t.string :linked_file_name
      t.string :linked_content_type
      t.integer :linked_file_size
      #end Paperclip Columns
      
      t.integer :stars
      t.integer :ratings
      
      t.integer :class_id
      t.string :semester
      t.integer :year
      
      t.timestamps
    end
  end

  def self.down
    drop_table :files
  end
end
