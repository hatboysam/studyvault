class School < ActiveRecord::Base
   attr_accessible :name
   
   has_many :users
   
   validates :name, :presence => true, :uniqueness => { :case_sensitive => false}
end