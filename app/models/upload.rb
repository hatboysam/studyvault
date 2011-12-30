class Upload < ActiveRecord::Base
    include SessionsHelper
    default_scope :order => 'uploads.created_at DESC'

    attr_protected :linked_file_name, :linked_content_type, :linked_size
  
    after_create :set_course_name
    
    belongs_to :user
    belongs_to :school
    belongs_to :course
    has_many :downloads, :source => :upload_id, :dependent => :destroy
    has_many :comments, :foreign_key => "file_id", :dependent => :destroy
    #belongs_to :class
    
    #paperclip
    has_attached_file :linked,
          :storage => :s3,
          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
          :path => ":class/:id/:attachment/:basename.:extension"
          
    #validations
    validates :school_id, :presence => true
    
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
    
    def course_name
      return course.full_name if course
    end
    
    def set_course_name
      @split = temp_coursename.split(' ', 2)
      @subject = @split.first
      @course_code = @split.last
      
      @conditions1 = {
        :full_name => temp_coursename,
        :school_id => school_id
      }
      
      @conditions2 = {
        :subject => @subject,
        :course_code => @course_code,
        :school_id => school_id,
        :full_name => temp_coursename
      }
      
      self.course = Course.find(:first, :conditions => @conditions1) || Course.create(@conditions2)
      self.save
    end
    
    
end