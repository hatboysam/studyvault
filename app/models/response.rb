class Response < ActiveRecord::Base
  attr_protected :linked_file_name, :linked_content_type, :linked_size
  
  belongs_to :request
  belongs_to :user
  belongs_to :upload
  
    #paperclip
    has_attached_file :linked,
                      :storage => :s3,
                      :s3_credentials => "config/s3.yml",
                      :path => ":class/:id/:attachment/:basename.:extension"
          
    validates_attachment_presence :linked
    validates_attachment_size :linked, :less_than => 100.megabyte
    validates_attachment_content_type :linked, {
      :content_type => [/[\w\W]*image[\w\W]*/, /[\w\W]*doc[\w\W]*/, /[\w\W]*sheet[\w\W]*/, /[\w\W]*pdf[\w\W]*/, /[\w\W]*presentation[\w\W]*/],
      :message => "invalid"
    }
    
    validates :description, :presence => true
    validates :request_id, :presence => true
    validates :user_id, :presence => true
    
    
    def assign_upload(upload)
      self.upload_id = upload.id
      self.save(:validate => false)
    end
  
end