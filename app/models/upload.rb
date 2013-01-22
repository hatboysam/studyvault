class Upload < ActiveRecord::Base
    default_scope :order => 'uploads.created_at DESC'

    attr_protected :linked_file_name, :linked_content_type, :linked_size
  
    after_create :set_course_name
    
    belongs_to :user
    belongs_to :school
    belongs_to :course
    has_many :downloads, :source => :upload_id, :dependent => :destroy
    has_many :comments, :foreign_key => "file_id", :dependent => :destroy

    
    HUMANIZED_ATTRIBUTES = {
      :email => "E-Mail address",
      :temp_coursename => "Course name"
    }
    
    
    #paperclip
    has_attached_file :linked,
          :storage => :s3,
          #:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
          :s3_credentials => "config/s3.yml",
          :path => ":class/:id/:attachment/:basename.:extension"
          
    coursename_regex = /[a-zA-Z]+\s[0-9]+/
          
    #validations
    validates :school_id, :presence => true
    
    validates :year, :presence => true
    
    validates :semester, :presence => true
    
    validates :temp_coursename, :presence => true,
                                :format => { :with => coursename_regex, 
                                              :message => "must be of the form Subject 123" }
    
    validates_attachment_presence :linked
    validates_attachment_size :linked, :less_than => 100.megabyte
    validates_attachment_content_type :linked, {
      :content_type => [/[\w\W]*image[\w\W]*/, /[\w\W]*doc[\w\W]*/, /[\w\W]*sheet[\w\W]*/, /[\w\W]*pdf[\w\W]*/, /[\w\W]*presentation[\w\W]*/],
      :message => "invalid"
    }
    
    
    
    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    
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
      self.save(:validate => false)
    end
    
    def course_name
      return course.full_name if course
    end

    def avg_rating
      return (self.stars/self.ratings)
    end

    def rating_class
      out_of_50 = self.avg_rating * 5;
      return "rating-static rating-#{out_of_50}"
    end
    
    def set_course_name
      @split = temp_coursename.split(' ')
      @clip = @split.size - 1
      
      for i in 0 ... @split.size
        @split[i] = @split[i].capitalize unless (@split[i] == @split[i].upcase)
      end
      
      @subject = @split.take(@clip).join(' ')
      @course_code = @split.last
      
      @full_name = @subject + " " + @course_code
      
      @conditions1 = {
        :full_name => @full_name,
        :school_id => school_id
      }
      
      @conditions2 = {
        :subject => @subject,
        :course_code => @course_code,
        :school_id => school_id,
        :full_name => @full_name
      }
      
      self.course = Course.find(:first, :conditions => @conditions1) || Course.create(@conditions2)
      self.save
    end
    
    
end