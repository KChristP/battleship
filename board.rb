class Board
  def initialize(grid = nil)
    @grid = grid == nil ? Board.default_grid : grid
    # @index_grid = []
    # @grid.each_with_index do |row, row_idx|
    #   @index_grid << row.each_with_index.map {|value, col_idx| row_idx.to_s + col_idx.to_s}
    # end
  end

  def self.default_grid
    Array.new(10) {Array.new(10)}
  end

  def grid
    @grid
  end

  def empty?(pos = @grid)
    if pos == @grid && count == 0
      true
    elsif pos == grid
      false
    else @grid[pos[0]][pos[1]] == nil
    end
  end

  def full?#needed for rspec tests
    count == @grid.length ** 2
  end

  def [](arr)#needed for rspec tests
    row = arr[0]
    col = arr[1]
    @grid[row][col]
  end

  def row_num(row)
    @grid[row]
  end

  def each_row(&block)
    @grid.each_with_index {|row, index| block.call(row, index)}
  end

  def column(col)
    @grid.map {|row| row[col]}
  end

  def each_column(&block)
    (0..9).each_with_index {|number, index| block.call(column(number), index)}
  end

  def row_or_column
    a_row = Proc.new {|row| @grid[row]}
    a_col = Proc.new {|col| @grid.map {|row| row[col]}}
    [a_row, a_col].sample
  end

  def display
    @grid.reverse_each {|row| p row}
  end

  def populate_grid
    random_place_ship(Ship.new(:carrier))
    random_place_ship(Ship.new(:battleship))
    random_place_ship(Ship.new(:submarine))
    random_place_ship(Ship.new(:destroyer))
    random_place_ship(Ship.new(:patrol))
  end

  def random_place_ship(ship)#yeah... this monster method needs refactoring...
    samples = {}

    row_or_col = ["row", "col"].sample

    if row_or_col == "row"
      each_row do |row, index|
        samples[index] = fitting_blocks(row, ship).sample
      end
    else
      each_column {|col, index| samples[index] = fitting_blocks(col, ship).sample}
    end#this should leave us with a samples hash containing the row/col index as a key, and a continuous set of indices containin nil

    samples.keep_if {|key, value| value != nil}

    r_or_c_num = samples.keys.sample
    starting_index = samples[r_or_c_num][0]

    if row_or_col == "row"
      i = 0
      ship.size.times do
        @grid[r_or_c_num][starting_index + i] = :s
        i += 1
      end

    else
      i = 0
      ship.size.times do
        @grid[starting_index + i][r_or_c_num] = :s
        i += 1
      end

    end
  end

  def place_random_ship#this is just to pass rspec tests, won't be used in actual game
    if full?
      raise "Board is full"
    else mark(random_coord, :s)
    end
  end

  def random_coord
    row = (0...@grid.length).to_a.sample
    col = (0...@grid.length).to_a.sample
    [row, col]
  end

  def mark(position, mark)
    row = position[0]
    col = position[1]
    @grid[row][col] = mark
  end

  def attack(position)
    row = position[0]
    col = position[1]
    if @grid[row][col] == :s
      @grid[row][col] = :x
    elsif @grid[row][col] == nil
      @grid[row][col] = :o
    else
      puts "Invalid move, try another position"
      attack(gets.chomp.split(", ").map {|x| x.to_i})
    end
  end

  def won?
    count == 0
  end

  def fitting_blocks(row_or_column, ship)
    fits = []
    consecutives = []
    row_or_column.each_with_index do |value, index|
      if value == nil && consecutives.length == ship.size
        fits << consecutives.map {|x| x}
        consecutives << index
        consecutives.shift
      elsif value == nil
        consecutives << index
      elsif value != nil
        consecutives = []
      end
    end

    fits
  end

  def count
    remaining_ships = 0
    @grid.each do |row|
      row.each {|mark| remaining_ships += (mark == :s ? 1 : 0)}
    end
    remaining_ships
  end
end


class Ship
  def initialize(type)
    ship_types = {carrier: 5, battleship: 4, submarine: 3, destroyer: 3, patrol: 2, cruiser: 3}
    @size = ship_types[type]
  end

  def size
    @size
  end
end
