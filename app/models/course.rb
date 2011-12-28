class Course < ActiveRecord::Base
    attr_accessible :subject, :course_code, :school_id
end