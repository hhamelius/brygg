require "bundler/setup"
require 'tty-prompt'

require 'brygg/client/punk_api_client'
require 'brygg/model/filter'
require 'brygg/version'

module Brygg

  class CLI

    def initialize
      @prompt = TTY::Prompt.new
      @filter = Filter.new
      @api = PunkApiClient.new
    end


    def select_search
      header
      choice = @prompt.select('Vad vill du söka på?') do |menu|
          menu.choice 'Alkoholhalt', 1
          menu.choice 'Mat', 2
          menu.choice 'Text', 3
          menu.choice 'Rensa sök-filter', 4
          menu.choice 'Sök',5
          menu.choice 'Avsluta',6
      end
      divider
      search_list(choice)
    end


    def search_list(choice)
      case choice
      when 1
        select_filter_by_abv false
      when 2
        select_filter_by_food
      when 3
        select_filter_by_text
      when 4
        clear_filter
      when 5
        do_search
      when 6
        do_exit
      else
        do_exit
      end
    end


    def select_filter_by_abv(skip)
      header
      unless skip
        choice_min = @prompt.ask("Lägsta alkoholhalt (ange ett nummer):", value: '0')
        if Filter.valid_abv? choice_min
          @filter.set_abv_min=choice_min
        else 
          select_filter_by_abv false
        end
      end
      choice_max = @prompt.ask("Högsta alkoholhalt (ange ett nummer):", value: '100')
      if Filter.valid_abv? choice_max
        @filter.set_abv_max=choice_max
      else 
        select_filter_by_abv true
      end
      select_search
    end


    def select_filter_by_food
      header
      choice_food = @prompt.ask('Ange önskade maträtter (på engelska, separerade med ett komma):')
      @filter.set_food=choice_food
      select_search
    end


    def select_filter_by_text
      header
      choice_text = @prompt.ask('Ange söktext:')
      @filter.set_text=choice_text
      select_search
    end


    def clear_filter
      @filter = Filter.new
      select_search
    end


    def do_search
      query = @filter.to_query
      beers = @api.get_beers query

      show_search_result beers
    end


    def show_search_result(beers)
      header
      list_beers beers
      choice = @prompt.select('Vad vill du göra?') do |menu|
        menu.choice 'Visa öl', 1
        menu.choice 'Nästa sida', 2
        menu.choice 'Föregående sida', 3
        menu.choice 'Ny sökning', 4
        menu.choice 'Avsluta', 5
      end
      divider
      search_action(choice, beers)
    end


    def search_action(choice, beers)
      case choice
      when 1
        select_beer_to_show beers
      when 2
        select_next_page
      when 3
        select_previous_page
      when 4
        clear_filter
        select_search
      when 5
        do_exit
      else 
        select_show_beer beers, choice
      end
    end


    def select_beer_to_show(beers)
      header
      list_beers beers
      range = @filter.range
      choice = @prompt.ask("Välj öl att visa:") do |q|
        q.in "#{range['min']}-#{range['max']}"
        q.messages[:range?] = "%{value} går inte att välja (%{in})"
      end
      next_beer = choice.to_i - range['min']
      select_show_beer beers, next_beer
    end


    def select_next_page
      @filter.next
      do_search
    end  


    def select_previous_page
      @filter.previous
      do_search
    end


    def select_show_beer(beers, choice)
      header
      list_beers beers
      puts beers[choice].description
      divider
      new_choice = @prompt.select('Vad vill du göra?') do |menu|
        menu.choice 'Nästa öl', [choice + 1, beers.length - 1].min
        menu.choice 'Föregående öl', [choice - 1, 0].max
        menu.choice 'Nästa sida', 11
        menu.choice 'Föregående sida', 12
        menu.choice 'Tillbaka', 13
        menu.choice 'Avsluta', 14
      end
      divider
      show_beer_action(new_choice, beers)
    end

    def show_beer_action(choice, beers)
      case choice
      when 11
        select_next_page
      when 12
        select_previous_page
      when 13
        show_search_result beers
      when 14
        do_exit
      else 
        select_show_beer beers, choice
      end
    end


    # -----
    # Presentation methods
    # -----

    def list_beers(beers)
      beers.each_index{|index| puts "#{index + @filter.range['min']} #{beers[index].short_description}"}
      divider
    end

    def header
      system("clear")
      title
      divider
      show_current_filter
      puts ''
    end

    def show_current_filter
      unless @filter.empty?
        puts 'Nuvarande sökfilter:'
        puts @filter.description
        divider
      end
    end

    def do_exit
      system('clear')
      system('exit')
    end

    def title 
      puts '             ____  ______   ______  ____ '
      puts '            | __ )|  _ \ \ / / ___|/ ___|'
      puts '            |  _ \| |_) \ V / |  _| |  _ '
      puts '            | |_) |  _ < | || |_| | |_| |'
      puts '            |____/|_| \_\|_| \____|\____|'
      puts '                                         '
      puts '            Hitta den rätta ölen för dig'
    end

    def divider
      puts '====================================================='
    end

  end

end
