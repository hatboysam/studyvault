class Subject < ActiveRecord::Base

	belongs_to :school

	validates_uniqueness_of :name, :scope => :school_id

end