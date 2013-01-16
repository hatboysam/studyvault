class User < ActiveRecord::Base
  default_scope :order => 'users.id ASC'
  
  attr_accessor :password
  attr_accessible :username, :email, :password, 
                  :password_confirmation, :confirmed, 
                  :school_id, :graduation, 
                  :admin, :stars, :credits, :school_name, :stars_redeemed,
                  :limbo_credits, :last_download_email, :downloads_since_email
  
  has_many :uploads, :dependent => :destroy
  belongs_to :school
  has_many :downloads, :source => :user_id, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  has_many :purchases
  
  has_many :responses, :dependent => :destroy 
  has_many :requests, :dependent => :destroy
  
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false}
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false}
  validates :school_id, :presence => { :message => "must be in our database, pick a school from the suggestions as you type"}
  #WARNING
  #THIS SHOULD REALLY BE BEFORE_SAVE
  before_create :encrypt_password
  
  #NECESSARY DUE TO POSTGRE
  after_create :set_defaults, :reset_downloads
  
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
    self.confirmed = true
    self.save(:validate => false)
  end
  
  #getter for school name
  def school_name
    school.name if school
  end
  
  #setter for school name (will create school if it didn't find one)
  def school_name=(name)
    self.school = School.find_by_name(name) unless name.blank?
  end
  
  def add_credits(num)
    self.credits += num
  end
  
  def get_stars(num)
    self.stars += num
    if self.stars >= 10
      self.stars_redeemed += 10
      self.stars -= 10
      self.credits += 1
    end
    self.save(:validate => false)
  end
  
  #WARNING 
  #THIS ALLOWS FOR NEGATIVE CREDITS
  def charge
    self.credits -= 1
    self.save(:validate => false)
  end
  
  def has_downloaded?(file)
    @downloads = self.downloads.find(:all, :conditions => "upload_id = #{file.id}")
    return (@downloads.length > 0)
  end
  
  def has_responded?(request)
    @responses = self.responses.find(:all, :conditions => "request_id = #{request.id}")
    return (@responses.length > 0)
  end
  
  def has_commented?(upload)
    @comments = upload.comments.find(:all, :conditions => {:user_id => self.id}) unless upload.nil?
    return (@comments.length > 0)
  end
  
  def make_request
    if self.limbo_credits.nil?
      self.limbo_credits = 0
    end
    self.limbo_credits += 2
    self.credits -= 2
    self.save(:validate => false)
  end
  
  def return_deposit
    self.limbo_credits -=2
    self.credits +=2
    self.save(:validate => false)
  end
  
  def response_accepted
    self.credits += 2
    self.save(:validate => false)
  end
  
  def add_swag(num)
    old_swag_div = (self.swag / 5000)
    new_swag_div = ((self.swag + num) / 5000)
    
    #this is if you've crossed a new 5000 SWAG mark
    if (new_swag_div > old_swag_div)
      self.credits += 2
    end
    
    self.swag += num
    self.save(:validate => false)
  end
  
  def add_download
    self.downloads_since_email += 1
    self.save(:validate => false)
  end
  
  def reset_downloads
    self.last_download_email = DateTime.now
    self.downloads_since_email = 0
    self.save(:validate => false)
  end
  
  def set_defaults
    stars_redeemed = 0
    swag = 100
    last_download_email = (DateTime.now - 1.days)
    downloads_since_email = 0
    self.save(:validate => false)
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