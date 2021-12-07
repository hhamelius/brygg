require 'test_helper'
require 'pp'
require 'json'

require 'brygg/client/punk_api_client'

class PunkApiTest < Minitest::Test

  def test_get_beers
    filter = Hash.new
    filter['page'] = 1
    filter['per_page'] = 2
    response = PunkApiClient.new.get_beers filter
    assert(response, "Response ok")
    assert(response.length == 2, "Number of beers ok")
  end

end
