class Download < ActiveRecord::Base
  
   belongs_to :upload
   
   default_scope :order => 'downloads.created_at DESC'
end