require 'csv'

namespace :db do
  
  desc "Import course data scraped from CourseRank"
  task :import_course_data => :environment do
  	#Hash of schools and codes
  	schoolcodes = Hash.new
    #First form a map of each school to real name 
    CSV.foreach("data/realnames.csv") do |row|
    	school = School.find_by_name(row[1])
    	if school.nil?
    		puts "Did not find #{row[1]}"
    	else
    		puts "Found #{row[1]}"
    		CSV.foreach("data/#{row[0]}-subjects.csv") do |subj|
    			Subject.create({ :name => subj[0], :school_id => school.id })
    		end
    	end
    end

    #Then find all matching schools in the database
    	#Load their subjects into subjects table

    #End the task (no idea why I need this, but I do)
    abort("Rake task done")
  end
end