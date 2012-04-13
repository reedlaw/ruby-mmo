class Player
  attr_accessor :proxy
  attr_reader :health, :level, :strength, :defense, :alive

  def initialize
    @health = 100
    @max_health = 100
    @level = 0
    @strength = 20
    @defense = 20
    @experience = 0
    @alive = true
  end


  #the attack move
  def attack(opponent)
    if opponent.class == Player || opponent.class == Monster
      points = @strength - opponent.defense/2
      opponent.suffer_damage(points)
    elsif opponent.nil?
      puts "No such opponent."     
    else
      raise "Can only attack Player objects. Object was #{opponent.class}"
    end
  end

   #the rest move
  def rest(arg)
    if @health <= @max_health
      @health = @health + 10
    end
    if @health > @max_health
      @health = @max_health
    end
  end

  #this is called when the player is the object of another player's attack
  def suffer_damage(points)
    if caller_method_name == "attack"
      @health = @health - points
      if @health <= 0
        puts "#{proxy} has died."
        @alive = false 
        @health = 0
      end
    else
      raise "Nice cheating attempt!"
    end
  end

  def stats
    { health: @health, level: @level, strength: @strength, defense: @defense, experience: @experience }
  end

  # Reward player with experiences after killing an opponent in group of certain size
  #
  # Experiences could be based on the opponents stats like level, reshare experiences, etc
  def reward(opponent, groupsize)
    @experience = @experience + 100 / groupsize
  end

  private

  def caller_method_name
    parse_caller(caller(2).first).last
  end

  def parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      file = Regexp.last_match[1]
      line = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      [file, line, method]
    end
  end
end
