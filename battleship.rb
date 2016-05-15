class BattleshipGame
  attr_reader :board, :player1, :player2

  def initialize(player1 = nil, board = nil, player2 = nil)
    @player1 = player1
    @player2 = player2
    @attacker = @player1
    @defender = @player2
    @board = board
  end

  def play_turn
    move = @attacker.get_play
    attack(move)
    @defender, @attacker = @attacker, @defender
  end

  def keenan_play_turn
    move = @attacker.get_play
    mark = @defender.defend(move)#this returns a mark :x or :o while also marking the defender's board
    @attacker.record_hit(move, mark)
    @defender.acknowledge(move, mark)
    @defender, @attacker = @attacker, @defender
  end

  def play
    populate_human_grid
    keenan_play_turn until who_lost
    puts "#{who_lost}'s fleet has been destroyed!"
  end

  def game_over?
    @board.won?
  end

  def who_lost
    if @player1.lost?
      @player1
    elsif @player2.lost?
      @player2
    else false
    end
  end

  def attack(pos)
    @board.mark(pos, :x)
  end

  def display_status
    @player1.display
  end

  def count
    @board.count
  end

  def populate_human_grid
    if @player1.class == HumanPlayer
      population_questions(@player1)
    end
    if @player2.class == HumanPlayer
      population_questions(@player2)
    end
  end

  def population_questions(player)
    player.display
    puts "Would you like to have your ships placed randomly (y/n)"
    if gets.chomp == "y"
      player.random_populate
    else
      17.times do
        puts "Enter coordinates to place a ship (row, col)"
        coords = gets.chomp.split(", ").map {|num| num.to_i}
        player.place_ship(coords)
      end
    end

  end
end
