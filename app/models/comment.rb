class Comment < ActiveRecord::Base
    attr_accessible :content, :user_id, :file_id, :rating
    
    after_save :apply_rating
    
    belongs_to :file, :class_name => "Upload"
    belongs_to :user
    
    def apply_rating
      self.file.update_rating
    end
end