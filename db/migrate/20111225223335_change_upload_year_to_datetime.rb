class ChangeUploadYearToDatetime < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      t.change :year, :datetime
    end
  end

  def self.down
    change_table :uploads do |t|
      t.change :year, :integer
    end
  end
end
