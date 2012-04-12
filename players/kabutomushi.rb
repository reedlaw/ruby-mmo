module Kabutomushi
  def to_s
    'Kabutomushi'
  end

  def move
    return kill_rat if rats_are_alive?
    return deliver_killing_blow if someone_is_killable?
    return attack strongest_player if healthy?
    rest
  end

  private

  # actions

  def attack(player)
    [:attack, player]
  end

  def rest
    [:rest]
  end

  def kill_rat
    attack find_player('rat')
  end

  def deliver_killing_blow
    attack killable_opponents.first
  end

  # conditions

  def rats_are_alive?
    find_player 'rat'
  end

  def someone_is_killable?
    killable_opponents.any?
  end

  def healthy?
    stats[:health] == 100
  end

  # information

  def weakest_player
    players.min { |a, b| a.stats[:health] <=> b.stats[:health] }
  end

  def strongest_player
    players.max { |a, b| a.stats[:experience] <=> b.stats[:experience] }
  end

  def killable_opponents
    players.select { |player| killable?(player) }
  end

  def potential_damage(player)
    stats[:strength] - player.stats[:defense]/2
  end

  def killable?(player)
    player.stats[:health] <= potential_damage(player)
  end

  def find_player(player_name)
    players.select { |player| player.to_s == player_name }.first
  end

  def players
    Game.world[:players].select { |player| player != self && player.alive }
  end
end
