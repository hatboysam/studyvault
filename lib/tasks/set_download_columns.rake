namespace :db do
  
  desc "Set download column defaults"
  task :set_download_columns => :environment do
    
    User.all.each do |user|
      user.last_download_email = 1.days.ago.time
      user.downloads_since_email = 0
    end
    
  end
end