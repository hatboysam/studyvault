class Upload < ActiveRecord::Base
    default_scope :order => 'uploads.created_at DESC'

    attr_protected :linked_file_name, :linked_content_type, :linked_size
    
    attr_accessible :user_id, :stars, :ratings, 
                    :semester, :professor, :year, 
                    :description, :course_id, :school_id, :course_name
  
    after_save :set_course_school
    
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
      return [course.subject, course.course_code].join(' ') if course
    end
    
    def course_name=(name)
      @split = name.split(' ', 2)
      @subject = @split.first
      @course_code = @split.last
      
      @conditions = {
        :subject => @subject,
        :course_code => @course_code,
        :school_id => self.school_id
      }
      
      self.course = Course.find(:first, :conditions => @conditions) || Course.create(@conditions)
    end
    
    def set_course_school
      course.set_school
    end
    
end