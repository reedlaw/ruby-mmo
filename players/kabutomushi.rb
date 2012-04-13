module Kabutomushi
  def to_s
    'Kabutomushi'
  end

  def move
    return kill_rat if d6 > 3 && rats_are_alive?
    return rest if d6 > 3 && people_are_passive?
    return deliver_killing_blow if d6 > 4 && someone_is_killable?
    return attack strongest_player if healthy?
    rest
  end

  def horde
    true
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

  def players_are_careful?
    weakest_player.stats[:health] > 70
  end

  # information

  def d6
    rand(6) + 1
  end

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
