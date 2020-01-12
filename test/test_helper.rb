ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # application_helper.rb に定義されている full_title メソッドを test 環境でも使えるように include する
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
end
