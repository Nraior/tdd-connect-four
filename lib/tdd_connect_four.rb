require_relative 'tdd_connect_four/game_controller'
require_relative 'tdd_connect_four/player'
require_relative 'tdd_connect_four/rules'

rules = Rules.new(7, 6)
game = GameController.new(rules)
player_one = Player.new('Damian', 'x', rules)
player_two = Player.new('George', 'o', rules)

game.update_players([player_one, player_two])

game.start_game
