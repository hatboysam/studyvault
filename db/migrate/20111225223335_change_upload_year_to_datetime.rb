class ChangeUploadYearToDatetime < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :year
    add_column :uploads, :year, :datetime
  end

  def self.down
    remove_column :uploads, :year
    add_column :uploads, :year, :integer
  end
end
