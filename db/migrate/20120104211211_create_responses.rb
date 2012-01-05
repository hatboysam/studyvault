class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer   :request_id
      t.integer   :user_id
      
      t.string    :linked_file_name
      t.string    :linked_content_type
      t.integer   :linked_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
