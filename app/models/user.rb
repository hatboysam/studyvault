class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :username, :email, :password, 
                  :password_confirmation, :confirmed, 
                  :school_id, :graduation, 
                  :admin, :stars, :credits
  
  has_many :uploads, :dependent => :destroy
  belongs_to :school
  has_many :downloads, :source => :user_id, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false}
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false}
  
  #WARNING
  #THIS SHOULD REALLY BE BEFORE_SAVE
  before_create :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil  if user.nil?
      return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_pepper(id, cookie_pepper)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.pepper == cookie_pepper
  end
  
  def confirm
    confirmed = true
  end
  
  #getter for school name
  def school_name
    school.name if school
  end
  
  #setter for school name (will create school if it didn't find one)
  def self.school_name=(name)
    self.school = School.find_or_create_by_name(name) unless name.blank?
  end
  
  def add_credits(num)
    self.credits += num
  end
  
  def charge
    self.credits -= 1
    self.save(false)
  end
  
  def has_downloaded?(file)
    @downloads = self.downloads.find(:all, :conditions => "upload_id = #{file.id}")
    return (@downloads.length > 0)
  end
  

  private
  
    def encrypt_password
      self.pepper = make_pepper unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{pepper}--#{string}")
    end
    
    def make_pepper
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end