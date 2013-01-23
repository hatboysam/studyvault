module CourseNameHelper
	def course_from_course_name(temp_coursename)
  	  split = temp_coursename.split(' ')
      clip = split.size - 1
      
      for i in 0 ... split.size
        split[i] = split[i].capitalize unless (split[i] == split[i].upcase)
      end
      
      subject = split.take(clip).join(' ')
      course_code = split.last
      
      full_name = subject + " " + course_code
      
      conditions1 = {
        :full_name => full_name,
        :school_id => school_id
      }
      
      conditions2 = {
        :subject => subject,
        :course_code => course_code,
        :school_id => school_id,
        :full_name => full_name
      }
      
      course = Course.find(:first, :conditions => conditions1) || Course.create(conditions2)
      return course
  	end
end