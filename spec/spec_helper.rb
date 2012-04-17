RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  
  config.add_setting :mock_player_count
  config.mock_player_count = (0..5)
end

Dir[File.expand_path("../support/*.rb",__FILE__)].each {|f| require f}
GameManager::Setup.perform_setup


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

def load_all_players_and_monsters
  @players = []
  GameManager::Setup.player_modules.each do |mod|
    @players << create_player_for_module(mod)
  end
  5.times do
    monster = Monster.new
    @game.players << monster
    r = PlayerProxy.new(monster)
    r.extend Rat
    monster.proxy = r
    @game.proxies << r
  end
end

def commence_rounds(num)
  @game.round(num)
end

def silence_output
  @original_stdout = $stdout
  $stdout = File.new('/dev/null', 'w')
end
