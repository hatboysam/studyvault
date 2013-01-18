namespace :db do
  
  desc "Set download column defaults"
  task :set_download_columns => :environment do
    
    User.all.each do |user|
      user.last_download_email = (DateTime.now - 1.days)
      user.downloads_since_email = 0
      user.save(:validate => false)
    end
    
  end
end