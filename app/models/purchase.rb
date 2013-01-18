class Purchase < ActiveRecord::Base
  
  attr_accessible :user_id, :credits, :goo
  
  belongs_to :user
  
  def make_good
    self.good = true
    self.save(:validate => false)
  end
  
end