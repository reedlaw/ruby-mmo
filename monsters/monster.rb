class Monster < Player
  def initialize
    @max_health = 10
    @health = 10
    @level = 0
    @strength = 2
    @defense = 2
    @experience = 0
    @alive = true
  end
end
  
