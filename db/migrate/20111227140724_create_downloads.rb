class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.integer :user_id
      t.integer :upload_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
