#require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  fixtures :pages
  # Replace this with your real tests.
	def test_valid_fields
	  page = pages(:valid_page)
	  assert page.valid?
	end
	


end
