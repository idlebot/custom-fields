ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# test helpers
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def drop_down_value_attributes(value, id = nil)
    attributes = {}
    attributes["value"] = value
    attributes["_destroy"] = 'false'
    attributes["id"] = id.to_s if id
    return attributes
  end

  def drop_down_value_destroy_attributes(value, id)
    attributes = {}
    attributes["value"] = value
    attributes["_destroy"] = '1'
    attributes["id"] = id.to_s if id
    return attributes
  end
end
