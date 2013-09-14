# Author: Chris St. John
# Email: chris@stjohnstudios.com
# Webume: http://www.linkedin.com/in/stjohncj

module Pwned
  def to_s; '__pwned'; end

  def move
    if should_rest?
      return [:rest, nil]
    else
      return [:attack, opponent_to_attack]
    end
  end

  private

  def opponent_to_attack
    attackee = best_opponent_to_kill
    if attackee.nil?
      if alive_opponents.count > reaper_trigger
        attackee = opponent_with_most_experience
      else
        attackee = opponent_with_least_health
      end
    end
    return attackee
  end

  def reaper_trigger
    return (most_health? or am_leading?) ? 1 : 5
  end

  def most_health?
    alive_opponents.each do |opponent|
      return false if opponent.stats[:health] > health
    end
    return true
  end

  def least_health?
    alive_opponents.each do |opponent|
      return false if opponent.stats[:health] < health
    end
    return true
  end

  def opponent_with_most_experience
    max_xp = 0
    potential_attackees = []
    alive_opponents.each do |opponent|
      max_xp = opponent.stats[:experience] if opponent.stats[:experience] > max_xp
    end
    alive_opponents.each do |opponent|
      potential_attackees << opponent if opponent.stats[:experience] == max_xp
    end
    return potential_attackees[rand(potential_attackees.count-1)]
  end

  def opponent_with_most_health
    max_health = 0
    potential_attackees = []
    alive_opponents.each do |opponent|
      max_health = opponent.stats[:health] if opponent.stats[:health] > max_health
    end
    alive_opponents.each do |opponent|
      potential_attackees << opponent if opponent.stats[:health] == max_health
    end
    return potential_attackees[rand(potential_attackees.count-1)]
  end

  def opponent_with_least_health
    min_health = 999999999
    potential_attackees = []
    alive_opponents.each do |opponent|
      min_health = opponent.stats[:health] if opponent.stats[:health] < min_health
    end
    alive_opponents.each do |opponent|
      potential_attackees << opponent if opponent.stats[:health] == min_health
    end
    return potential_attackees[rand(potential_attackees.count-1)]
  end

  def best_opponent_to_kill
    earned_xp = 0
    potential_attackees = []

    alive_opponents.each do |opponent|
      opponent_player = player_for(opponent)
      if can_kill?(opponent) and opponent_player.max_health > earned_xp
        earned_xp = opponent_player.max_health
      end
    end

    alive_opponents.each do |opponent|
      opponent_player = player_for(opponent)
      if can_kill?(opponent) and (opponent_player.max_health == earned_xp)
        potential_attackees << opponent
      end
    end

    opponent_count = alive_opponents.count
    if opponent_count > 20
      target = random_from(potential_attackees)
    elsif opponent_count > 5
      target = second_highest_rated_from(potential_attackees)
    else
      target = highest_rated_from(potential_attackees)
    end

    return target
  end

  def random_from(opponents)
    opponents[rand(opponents.count-1)]
  end

  def highest_rated_from(opponents)
    opponents.sort_by {|o| [ o.stats[:experience], o.stats[:strength], o.stats[:defense], o.stats[:health] ] }
    opponents.last
  end

  def second_highest_rated_from(opponents)
    opponents.sort_by {|o| [ o.stats[:experience], o.stats[:strength], o.stats[:defense], o.stats[:health] ] }
    opponents[opponents.count-2]
  end

  def should_rest?
    return false if health >= max_health
    return true if least_health? or is_vulnerable? or is_likely_vulnerable_to_mob?
    return true if best_opponent_to_kill.nil? and not am_leader?
    return false
  end

  def is_vulnerable?
    alive_opponents.each do |opponent|
      return true if could_kill_me?(opponent)
    end
    return false
  end

  def is_vulnerable_to_mob?
    hp_left = health
    alive_opponents.each do |opponent|
      hp_left -= damage_for(opponent,self)
    end
    return hp_left <= 0
  end

  def is_likely_vulnerable_to_mob?
    total_damage = 0
    alive_opponents.each do |opponent|
      total_damage += damage_for(opponent,self)
    end
    total_likely_damage = total_damage / 2
    return health - total_likely_damage <= 0
  end

  def can_kill?(opponent)
    hp_left = opponent.stats[:health] - damage_for(self,opponent)
    return hp_left <= 0
  end

  def could_kill_me?(opponent)
    hp_left = health - damage_for(opponent,self)
    return hp_left <= 0
  end

  def damage_for(attacker, attackee)
    attacker.stats[:strength] - attackee.stats[:defense]/2
  end

  def alive_opponents
    Game.world[:players].select{|p| p != self && p.alive }
  end

  def health
    player.health
  end

  def max_health
    player.max_health
  end

  def strength
    player.strength
  end

  def defense
    player.defense
  end

  def experience
    player.instance_variable_get :@experience
  end

  def player
    player = self.instance_variable_get :@player
  end

  def player_for(opponent)
    player = opponent.instance_variable_get :@player
  end

  def am_leader?
    alive_opponents.each do |opponent|
      return false if opponent.stats[:experience] > experience
    end
    return true
  end

end
