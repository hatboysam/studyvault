class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :encrypted_password
      t.string :pepper
      t.string :email
      
      t.integer :school_id
      t.integer :credits
      t.integer :stars
      t.integer :files
      t.integer :graduation
      
      t.boolean :admin, :default => false
      t.boolean :confirmed, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
