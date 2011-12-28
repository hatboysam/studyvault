class AddProfessorToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :professor, :string
  end

  def self.down
    remove_column :uploads, :professor
  end
end
