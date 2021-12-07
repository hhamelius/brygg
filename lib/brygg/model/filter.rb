
class Filter

  attr_reader :text, :food, :abv_min, :abv_max, :per_page, :page

  def initialize
    @text = ''
    @food = []
    @abv_min = 0.0
    @abv_max = 100.0
    @page = 1
    @per_page = 10
  end

  def range
    min = (@page - 1) * @per_page + 1
    Hash['min' => min, 'max' => min + @per_page - 1]
  end

  def set_text=(value)
    @text = value
  end

  def set_food=(value)
    if value
      @food = value.split(',').collect { |food| food.strip }
    end
  end

  def set_abv_min=(value)
    if value
      @abv_min = value.to_f
    end
  end

  def set_abv_max=(value)
    if value
      @abv_max = value.to_f
    end
  end

  def next
    @page += 1
  end

  def previous
    if @page > 1
      @page -= 1
    else
      @page
    end
  end

  def description
    "Alkoholhalt: #{@abv_min}% - #{@abv_max}%\nMaträtter: #{@food.to_s}\nText: #{@text}"
  end

  def empty?
    !(@text || @food || @abv_min || @abv_max)
  end

  def to_query
    query = Hash.new
    query['abv_gt'] = @abv_min
    query['abv_lt'] = @abv_max
    if @food.length > 0
      query['food'] = @food.join(',')
    end
    if @text.length > 0
      query['beer_name'] = @text
    end
    query['page'] = @page
    query['per_page'] = @per_page
    query
  end

  def self.valid_abv?(value)
    if value
      value.match?(/\A\d+\.?\d*\z/)
    else
      false
    end
  end

end