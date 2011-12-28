class MakeSchoolNameUnique < ActiveRecord::Migration
  def self.up
    add_index :schools, :name, :unique => true
  end

  def self.down
    remove_index :schools, :name
  end
end
