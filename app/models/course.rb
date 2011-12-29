class Course < ActiveRecord::Base
    attr_accessible :subject, :course_code, :school_id, :course_name
    
    belongs_to :school
    has_many   :uploads
    
    def course_name
      return [subject, course_code].join(' ')
    end
    
    def course_name=(name)
      split = name.split(' ', 2)
      self.subject = split.first
      self.course_code = split.last
    end
    
    def set_school
      @first = self.uploads.all.first
      self.school_id = @first.school_id
      self.save(false)
    end
        
end