require 'test_helper'
require 'pp'

require_relative '../lib/brygg/model/beer.rb'

class PunkApiTest < Minitest::Test

  def test_short_description
    beer = Beer.new(1, 'Test Beer', 'A very testing beer', ["turtle soap"], '5.0')
    expected = "Test Beer - 5.0%\n\n"
    assert_equal(beer.short_description, expected, "Short description of beer failed")
  end

  def test_description
    beer = Beer.new(1, 'Test Beer', 'A very testing beer', ["turtle soap"], '5.0')
    expected = "Namn: Test Beer \nAlkoholhalt: 5.0%\nBeskrivning: A very testing beer\nLämplig mat: [\"turtle soap\"]\n\n"
    assert_equal(beer.description, expected, "Short description of beer failed")
  end

end
