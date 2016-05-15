class HumanPlayer
  def initialize(name = nil)
    @name = name
    @my_board = Board.new
    @enemy_board = Board.new
  end

  def get_play
    puts "Please input coordinates to attack in the format row, column"
    move = gets.chomp.split(", ").map {|move| move.to_i}
  end

  def record_hit(pos, mark)
    @enemy_board.mark(pos, mark)
    if mark == :x
      puts "\nYou scored a HIT!!!!!"
    else
      puts "\nYou missed"
    end
    puts "\nReconnaissance:\n"
    @enemy_board.display
  end

  def defend(pos)
    @my_board.attack(pos)
  end

  def acknowledge(move, mark)
    puts "Your Enemy attacked #{move}"
    if mark == :x
      puts "YOUVE BEEN HIT!"
    else
      puts "They missed!"
    end

    puts "\nYour fleet:\n"
    @my_board.display
  end

  def lost?
    @my_board.won?
  end

  def display
    @my_board.display
  end

  def random_populate
    @my_board.populate_grid
    puts "\nThis is your fleet:"
    @my_board.display
  end

  def place_ship(pos)
    @my_board.mark(pos, :s)
  end
end

class ComputerPlayer
  def initialize(name = nil)
    @name = name
    @my_board = Board.new
    @my_board.populate_grid
    @enemy_board = Board.new
    @hits = []
    @shots = []
  end

  def my_board
    @my_board
  end

  def lost?
    @my_board.won?
  end

  def get_play
    select_square
  end

  def record_hit(pos, mark)
    # @enemy_board.mark(pos, mark)
    if mark == :x
      @hits << pos
      @shots << pos
    else
      @shots << pos
    end
  end

  def defend(pos)
    @my_board.attack(pos)
  end

  def select_square
    touch = find_touching_hit
    if touch != false
      touch
    else
      random_attack
    end
  end

  def random_attack
    pos = @enemy_board.random_coord
    @shots.include?(pos) ? random_attack : pos
  end

  def find_touching_hit
    i = 0
    while i < @hits.length
      if hit_explorer(@hits[i]) == false
      else
        return hit_explorer(@hits[i])
      end
      i += 1
    end

    false
  end

  def hit_explorer(pos)
    touching_squares = [above_hit(pos), below_hit(pos), right_of_hit(pos), left_of_hit(pos)] - [nil]
    touching_squares.each do |pos|
      if @shots.include?(pos)
        next
      else
        return pos
      end
    end

    false
  end

  def above_hit(pos)
    if pos[0] == 9
      nil
    else
      [pos[0] + 1, pos[1]]
    end
  end

  def right_of_hit(pos)
    if pos[1] == 9
      nil
    else
      [pos[0], pos[1] + 1]
    end
  end

  def left_of_hit(pos)
    if pos[1] == 0
      nil
    else
      [pos[0], pos[1] - 1]
    end
  end

  def below_hit(pos)
    if pos[0] == 0
      nil
    else
      [pos[0] - 1, pos[1]]
    end
  end

  def acknowledge(move, mark)
  end

  def display
    @my_board.display
  end
end
