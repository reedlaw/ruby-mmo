[:engine,:monsters].each do |dir|
  Dir[File.expand_path("../../#{dir}/*.rb",__FILE__)].each {|f| require f}
end

require File.expand_path("../../players/dank",__FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  
  config.add_setting :mock_player_count
  config.mock_player_count = (0..5)
end

Dir[File.expand_path("../support/*.rb",__FILE__)].each {|f| require f}

def start_game
  @game = Game.new
end

def create_player_for_module(mod)
  player = Player.new
  @game.players << player
  p = PlayerProxy.new(player)
  p.extend mod
  player.proxy = p
  @game.proxies << p
  p
end

def commence_round
  @game.round(1)
end

def silence_output
  @original_stdout = $stdout
  $stdout = File.new('/dev/null', 'w')
end