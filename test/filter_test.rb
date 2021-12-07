require 'test_helper'
require 'pp'
require 'json'

require_relative '../lib/brygg/model/filter.rb'

class PunkApiTest < Minitest::Test

  def test_range
    filter = Filter.new
    expected = Hash['min' => 1, 'max' => 10]
    assert_equal(expected['min'], filter.range['min'], "Min range failed")
    assert_equal(expected['max'], filter.range['max'], "Max range failed")

    filter.previous
    expected = Hash['min' => 1, 'max' => 10]
    assert_equal(expected['min'], filter.range['min'], "Min range failed to stop at first page")
    assert_equal(expected['max'], filter.range['max'], "Max range failed to stop at first page")

    filter.next
    expected = Hash['min' => 11, 'max' => 20]
    assert_equal(expected['min'], filter.range['min'], "Min range failed to move to next page")
    assert_equal(expected['max'], filter.range['max'], "Max range failed to move to next page")

    filter.previous
    expected = Hash['min' => 1, 'max' => 10]
    assert_equal(expected['min'], filter.range['min'], "Min range failed to move to previous page")
    assert_equal(expected['max'], filter.range['max'], "Max range failed to move to previous page")
  end

  def test_query
    default_filter = Filter.new
    assert_equal(0.0, default_filter.abv_min, "Filter failed to set default abv min")
    assert_equal(100.0, default_filter.abv_max, "Filter failed to set default abv max")
    assert_equal(1, default_filter.page, "Filter failed to set default page")
    assert_equal(10, default_filter.per_page, "Filter failed to set default page size")

    expected = Hash.new
    expected['abv_gt'] = 8.0
    expected['abv_lt'] = 10.0
    expected['food'] = "bacon,cheese"
    expected['beer_name'] = "Dog"
    expected['page'] = 1
    expected['per_page'] = 10

    full_filter = Filter.new
    full_filter.set_abv_min = '8.0'
    full_filter.set_abv_max = '10.0'
    full_filter.set_food = "bacon, cheese"
    full_filter.set_text = "Dog"
    query = full_filter.to_query
    assert_equal(expected, query, "Failed to generate correct query")
  end

end
