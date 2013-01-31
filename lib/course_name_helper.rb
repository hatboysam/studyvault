module CourseNameHelper

  #First letter of a word
  def initial(string)
    string[0,1]
  end

  #Is a word all numbers?
  def numeric?(string)
    true if Float(string) rescue false
  end

  #Split string into words
  def words(string)
    string.split(' ')
  end

  #Find a Course object from a string name
	def course_from_course_name(temp_coursename)
  	  split = words(temp_coursename)
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

    #Convert a long name to an acronym
    def to_subject_acronym(coursename)
      acronym = ""
      stop_words = ["and", "is", "in", "of", "the"]
      split = words(coursename)
      for i in 0 ... split.size
        word = split[i]
          #Not numeric
          if !numeric?(word)
            #Already an abbreviation
            if word == word.upcase
              acronym += word
            elsif !numeric?(word) && !stop_words.include?(word)
              first_letter = initial(word)
              acronym += first_letter
            end
          end
      end

      engineering = false
      if split[0].downcase.include?("engineering")
        engineering = true
      elsif split.map{|x| x.downcase}.include?("engineering")
        engineering = true
      end

      if engineering && (acronym[-1,1] != "E")
        acronym += "E"
      end
      return acronym
    end

    def first_word_acronym(coursename)
      split = words(coursename)
      first_word = split[0].downcase
      vowels = ["a","e","i","o","u"]
      devoweled = first_word[1,100].chars.find_all{|x| !vowels.include?(x)}.join
      first_four = first_word[0] + devoweled[0,3]
      return first_four.upcase
    end

    #Get a course code out of a name
    def to_course_code(coursename)
      split = words(coursename)
      for i in 0 ... split.size
        if numeric?(split[i])
          return split[i]
        end
      end
      return "101"
    end

    def join_name_and_code(coursename,coursecode)
      "#{coursename} #{coursecode}"
    end

    #Suggest a course name
    #Ex: "Computer and Information Science 120 => CIS 120"
    #Ex: "Biological Basis of Behavior => BBB 101"
    def full_course_name_suggestion(coursename)
      acronym = to_subject_acronym(coursename)
      code = to_course_code(coursename)
      join_name_and_code(acronym, code)
    end

    def first_word_suggestion(coursename)
      acronym = first_word_acronym(coursename)
      code = to_course_code(coursename)
      join_name_and_code(acronym, code)
    end

    def suggestions_list(coursename)
      sugg1 = full_course_name_suggestion(coursename)
      sugg2 = first_word_suggestion(coursename)
      [sugg1, sugg2]
    end
end