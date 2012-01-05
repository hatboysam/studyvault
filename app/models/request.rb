class Request < ActiveRecord::Base
  default_scope :order => 'requests.created_at DESC'
  
  belongs_to :school
  belongs_to :course
  belongs_to :user
  has_many   :responses, :dependent => :destroy
  
  after_create :set_course_name
  
  coursename_regex = /[a-zA-Z]+\s[0-9]+/
          
    #validations
    validates :school_id, :presence => true
    
    validates :year, :presence => true
    
    validates :semester, :presence => true
    
    validates :temp_coursename, :presence => true,
                                :format => { :with => coursename_regex, 
                                              :message => "must be of the form Subject 123" }
                                      
    validates :description, :presence => true
  
  
  def course_name
      return course.full_name if course
  end
    
  def set_course_name
      @split = temp_coursename.split(' ')
      @clip = @split.size - 1
      
      for i in 0 ... @split.size
        @split[i] = @split[i].capitalize
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