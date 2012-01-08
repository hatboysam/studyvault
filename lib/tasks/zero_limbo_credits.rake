namespace :db do
  
  desc "Set limbo credits to zero"
  task :zero_limbo_credits => :environment do
    
    User.all.each do |user|
      user.limbo_credits = 0
      user.save(false)
    end
    
  end
end