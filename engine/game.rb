class Game
  attr_reader :players, :proxies

  class << self
    attr_accessor :world
  end

  def initialize
    @players = []
    @proxies = []
  end


  #This is the method that actually calculates the game and implements the rounds
  def round(count)


    #gameplay
    count.times do |i|
      puts "Round #{i}"
      update_world
      @players.each do |p|

        #This goes through and calculates if the player is dead
        if p.alive == false
          @players.delete(p)
          @proxies.delete(p.proxy)
          next
        end

        #This determines a player's attack phase
        unless p.kind_of? Monster
          move = p.proxy.move #move is actually the player's action, not their physical move.
          m = move.first
          case m
          when :attack
            prep = " "
            o = move.last
            object = @players.select {|p|p.proxy == o}.first
          when :rest
            prep = ""
            o = ""
          else
            prep = " with "
          end
          puts "#{p.proxy} #{m}s#{prep}#{o}."

          p.send(m, object) #This invokes the m method in the player class, and invokes that upon object
        end
      end
    end

    #results
    puts "Results:"
    @proxies.sort_by(&:to_s).each do |p|
      puts "#{p}: #{p.stats}"
    end
    winner = @proxies.inject(@proxies[0]) {|max, item| item.stats[:experience] > max.stats[:experience] ? item : max }
    puts "#{winner} is the winner!"


  end

  private
  
  def update_world
    self.class.world = { players: @proxies }
  end
end
