class Beer

  def initialize(id, name, description, food, abv)
    @id = id
    @name = name
    @description = description
    @food = food
    @abv = abv
  end

  def short_description
    "#{@name} - #{@abv}%\n\n"
  end

  def description
    "Namn: #{@name} \nAlkoholhalt: #{@abv}%\nBeskrivning: #{@description}\nLämplig mat: #{@food}\n\n"
  end

end

