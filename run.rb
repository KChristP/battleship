require "./player.rb"
require "./board.rb"
require "./battleship.rb"

player1 = ComputerPlayer.new
player2 = HumanPlayer.new
board = Board.new
game = BattleshipGame.new(player1, 0, player2)
game.play
