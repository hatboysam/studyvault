class Comment < ActiveRecord::Base
    default_scope :order => 'comments.created_at DESC'
    attr_accessible :content, :user_id, :file_id, :rating
    
    after_save :apply_rating
    
    after_create :give_stars
    
    belongs_to :file, :class_name => "Upload"
    belongs_to :user
    
    validates :file_id, :presence => true
    validates :user_id, :presence => true
    validates :rating, :presence => true
    
    def apply_rating
      self.file.update_rating
    end
    
    def give_stars
      self.file.user.get_stars(self.rating)
    end

    def rating_class
        out_of_50 = rating * 5;
        return "rating-static rating-#{out_of_50}"
    end
end