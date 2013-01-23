class Request < ActiveRecord::Base
  include CourseNameHelper

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
      self.course = course_from_course_name(self.temp_coursename)
      self.save
  end
  
end