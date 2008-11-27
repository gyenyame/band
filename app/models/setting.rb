class Setting < ActiveRecord::Base
  has_one :promo
  has_one :color
  
  has_many :members
  has_many :pages
  has_many :web_profiles
  has_many :songs
  
	validates_email_veracity_of :email, :message => "Email is invalid"
	validates_email_veracity_of :admin_email, :message => "Email is invalid"
		
	def songs_host
	  host = attributes['songs_host'].blank? ? url : with_protocol(attributes['songs_host'])
	end
	
	def show_videos?
	  !youtube_profile.blank? && read_attribute(:show_videos)
	end
	
	def show_twitter?
	  !twitter_profile.blank? && read_attribute(:show_twitter)
	end
  
  def url_with_protocol
	  with_protocol(attributes['url'])
  end
  
  protected
  
  def with_protocol link
	  link = link.match(/^http:\/\//) ? link : "http://#{link}"
	  #link = link.match(/\/$/) ? link : "#{link}/"
	  link.gsub(/\/$/, "")
  end
end
