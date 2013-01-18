namespace :db do
  
  desc "Set swag to zero"
  task :zero_swag => :environment do
    
    User.all.each do |user|
      user.swag = 100
      user.save(:validate => false)
    end
    
  end
end