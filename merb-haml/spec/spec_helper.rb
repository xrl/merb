require "rubygems"

# Use current merb-core sources if running from a typical dev checkout.
lib = File.expand_path('../../../merb-core/lib', __FILE__)
$LOAD_PATH.unshift(lib) if File.directory?(lib)
require 'merb-core'

# The lib under test
require "merb-haml"

# Satisfies Autotest and anyone else not using the Rake tasks
require 'spec'

# Shared spec files
require "controllers/haml"

Merb::Plugins.config[:haml] = { "autoclose" => ["foo"] }

Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
