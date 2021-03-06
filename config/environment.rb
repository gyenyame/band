# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_band_session',
    :secret      => '7aa14b7b3fa811a92ff86a7bed08fec47b49695c53e7d3034e7328074111b1e32523d4e865a5de4f64bbb9e8a4bc677931e2e691cb53b8c4344b384d7c2ebba7'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  #config.frameworks += [:action_web_service]
  #config.action_web_service = Rails::OrderedOptions.new
  #config.load_paths += %W( #{RAILS_ROOT}/app/apis )
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  
  config.load_paths += %W( #{RAILS_ROOT}/app/apis )
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
  config.gem "httparty"

end
require 'try'
require "#{RAILS_ROOT}/vendor/gems/twitter-0.3.7/lib/twitter"

RCC_PUB = "6LfxUQQAAAAAAEwuipNG2xYZyC7kZyDOm6QEcbBn"
RCC_PRIV= "6LfxUQQAAAAAAAXACByW_uKKsn26uDuYWLCgBEI4"

WillPaginate::ViewHelpers.pagination_options[:param_name] = :p

# TagList.delimiter = " "

WIDESCREEN = 1
STANDARD = 2

VIDEO_HEIGHT = { WIDESCREEN => 295, STANDARD => 350 }
VIDEO_WIDTH = { WIDESCREEN => 480, STANDARD => 415 }
VIDEO_LABELS = { WIDESCREEN => "widescreen", STANDARD => "standard" }

MAX_TWITTER_COUNT = 4

US_STATES = ['AL' => 'Alabama', 'AK' => 'Alaska', 'AR' => 'Arizona', 'AZ' => 'Arkansas', 'CA' => 'California', 'CO' => 'Colorado', 'CT' => 'Connecticut', 'DE' => 'Delaware', 'DC' => 'District of Columbia', 'FL' => 'Florida', 'GA' => 'Georgia', 'HI' =>
 'Hawaii', 'ID' => 'Idaho','IL' => 'Illinois', 'IN' => 'Indiana', 'IA' => 'Iowa', 'KS' => 'Kansas', 'KY' => 'Kentucky', 'LA' => 'Lousiana', 'ME' => 'Maine', 'MD' => 'Maryland', 'MA' => 'Massachusetts', 'MI' => 'Michigan', 'MN' => 'Minnesota', 'MS' =>
 'Mississippi', 'MO' => 'Missouri', 'MT' => 'Montana', 'NC' => 'North Carolina', 'ND' => 'North Dakota', 'NE' => 'Nebraska', 'NH' => 'New Hampshire', 'NJ' => 'New Jersey', 'NM' => 'New Mexico', 'NV' => 'Nevada', 'NY' => 'New York', 'OH' => 'Ohio', 'OK' =>
 'Oklahoma', 'OR' => 'Oregon', 'PA' => 'Pennsylvania', 'RI' => 'Rhode Island', 'SC' => 'South Carolina', 'SD' => 'South Dakota', 'TN' => 'Tennessee', 'TX' => 'Texas', 'UT' => 'Utah', 'VT' => 'Vermont', 'VA' => 'Virgina', 'WA' => 'Washington', 'WV' =>
 'West Virginia', 'WI' => 'Wisconsin', 'WY' => 'Wyoming']
