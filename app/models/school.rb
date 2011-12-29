class School < ActiveRecord::Base
   attr_accessible :name
   
   has_many :users
   has_many :uploads
   has_many :courses
   
   validates :name, :presence => true, :uniqueness => { :case_sensitive => false}
end