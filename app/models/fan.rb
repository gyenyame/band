require 'digest/sha1'

class Fan < ActiveRecord::Base
  acts_as_taggable
  
	validates_presence_of :email, :zipcode
	validates_email_veracity_of :email
	validates_uniqueness_of :email, :case_sensitive => false
	#validates_numericality_of :zipcode
	#validates_inclusion_of :zipcode, :in => 00501..99999, :message => "must be 5 digits"
		
	before_save :encrypt_email
	
	def tag	  
  end
  
  def list_tags
    self.tag_list.join(" ")
  end
  
  def list_tags= list
    list = list.gsub(',',' ')
    self.tag_list = list.split.join(" ")   
  end
		
	def name= full_name
	  unless full_name.nil?
      full_name = full_name.split
      firstname = full_name.delete_at(0)
      lastname = full_name.join(' ')
      self.firstname = firstname
      self.lastname = lastname
    end
	end
	
	def self.find_tagged list
	  list = list.gsub(',',' ')
	  self.find_tagged_with(list, :match_all => true)
	end
	
	def name
	  [firstname, lastname].join(' ')
  end
  
  def address
    [[city, state].join(', '), zipcode].join(' ')
  end
	
	def self.search(search, page)
	  search.strip!
    if search
      if search.match(/^tags: /)
        tags = search.gsub(/^tags:/, "")
        tags.gsub!(",", " ")
        tags = tags.split
        paginate_tagged_with(tags, :match_all => true, :order => 'created_at DESC', :page => page)
      else
        search = "%#{search}%"
        paginate :per_page => 25, :page => page,
          :conditions => ['firstname LIKE ? OR lastname LIKE ? OR email LIKE ? OR zipcode LIKE ?', search, search, search, search],
          :order => 'created_at DESC'
      end
    else
      find(:all)
    end
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  # Encrypts the email with the user salt
  def encrypt(password)
    self.class.encrypt(email, salt)
  end
  
  protected
    def encrypt_email
      return if email.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_email = encrypt(email)
    end
end
