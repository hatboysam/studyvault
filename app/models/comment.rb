class Comment < ActiveRecord::Base
    attr_accessible :content, :user_id, :file_id, :rating
    
    after_save :apply_rating
    
    after_create :give_stars
    
    belongs_to :file, :class_name => "Upload"
    belongs_to :user
    
    def apply_rating
      self.file.update_rating
    end
    
    def give_stars
      self.file.user.get_stars(self.rating)
    end
end