namespace :db do
  
  desc "import school data from csv"
  task :import_school_data => :environment do
    require 'fastercsv'
    
    FasterCSV.foreach("schools.csv") do |row|
      School.create(
        :name => row[1]
      )
    end
  end
end