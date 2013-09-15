# Author:   Chris St. John
# Email:    chris@stjohnstudios.com
# Webume:   http://www.linkedin.com/in/stjohncj

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
        if groups_roaming?
          attackee = highest_rated_from(grouped_opponents)
        else
          attackee = highest_rated_from(alive_opponents)
        end
      else
        attackee = opponent_with_least_health
      end
    end
    if attackee.nil? #should be just me and my clones
      attackee = random_from(alive_pwned)
    end
    return attackee
  end

  def groups_roaming?
    alive_opponents.each do |opponent|
      return true if is_in_a_group?(opponent)
    end
    return false
  end

  def grouped_opponents
    opponents = []
puts '---------------------->'
    alive_opponents.each do |opponent|
puts opponent.to_s + ' is in a group? ' + is_in_a_group?(opponent).to_s
      opponents << opponent if is_in_a_group?(opponent)
    end
  end

  def is_in_a_group?(opponent)
    player_for(opponent).class.method_defined?(:friends)
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

  def opponent_with_least_health
    min_health = 999999999
    potential_attackees = []
    alive_opponents.each do |opponent|
      min_health = opponent.stats[:health] if opponent.stats[:health] < min_health
    end
    alive_opponents.each do |opponent|
      potential_attackees << opponent if opponent.stats[:health] == min_health
    end
    return potential_attackees.first
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

    count = potential_attackees.count
    if count >= 5
      potential_attackees.shift
      potential_attackees.pop
    elsif count == 4
      potential_attackees.shift
    end
    target = my_target_in(potential_attackees)
    return target
  end

  def my_target_in(opponents)
    opponents[0]
  end

  def alive_pwned
    Game.world[:players].select{|p| p.alive && p.to_s =~ /^__pwned/ }
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
    opponents.count>=2 ? opponents[opponents.count-2] : opponents[opponents.count-1]
  end

  def should_rest?
    return true if is_vulnerable? or in_mob_attack_danger?
    return false
  end

  def is_vulnerable?
    alive_opponents.each do |opponent|
      return true if could_kill_me?(opponent)
    end
    return false
  end

  def in_mob_attack_danger?
    return false if experience == 0
    return true if am_leader? or least_health?
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
    Game.world[:players].select{|p| p != self && p.alive && p.to_s !~ /^__pwned/ }
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

module PwnedCloneLeft
  include Pwned

  def to_s; "__pwned_clone_left"; end

  def should_rest?
    return true if is_vulnerable? or in_mob_attack_danger?
    return true if alive_opponents.count == 0 # bow to my master
    return false
  end

  def my_target_in(opponents)
    opponents[-1]
  end
end

module PwnedCloneRight
  include Pwned

  def to_s; "__pwned_clone_right"; end

  def should_rest?
    return true if is_vulnerable? or in_mob_attack_danger?
    return true if alive_opponents.count == 0 # bow to my master
    return false
  end

  def my_target_in(opponents)
    opponents[1]
  end
end
