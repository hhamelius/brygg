require 'rest-client'
require 'json'
require 'pp'

require_relative '../model/beer.rb'

class PunkApiClient

  def initialize
    @base_url = 'https://api.punkapi.com/v2/beers'
  end

  def get_beers(filter = { per_page: 10, page: 1 })
    begin
      response = RestClient.get @base_url, { params: filter, headers: { accept: 'application/json' } }
      beers = JSON.parse(response.body)
      beers.collect { |beer| Beer.new(beer['id'], beer['name'], beer['description'], beer['food_pairing'], beer['abv']) }
    rescue RestClient::ExceptionWithResponse => err
      err.response
    end

  end

end