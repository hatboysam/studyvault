class Upload < ActiveRecord::Base
    default_scope :order => 'uploads.created_at DESC'
  
    attr_protected :linked_file_name, :linked_content_type, :linked_size
  
    belongs_to :user
    has_many :downloads, :source => :upload_id, :dependent => :destroy
    has_many :comments, :foreign_key => "file_id", :dependent => :destroy
    #belongs_to :class
    
    #paperclip
    has_attached_file :linked,
          :storage => :s3,
          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
          :path => ":class/:id/:attachment/:basename.:extension"
          
    #validations
    validates :class_id, :presence => true
    
    def update_rating
      @comments = self.comments.all
      if @comments.length > 0
        @stars = 0
        @comments.each do |comment|
          @stars += comment.rating
        end
        self.stars = @stars
        self.ratings = @comments.length
      end
      self.save(false)
    end
end