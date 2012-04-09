class Game
  attr_reader :players, :proxies

  class << self
    attr_accessor :world
  end

  def initialize
    @players = []
    @proxies = []
  end
  
  def round(count)
    count.times do |i|
      p "Round #{i}"
      update_world
      @players.each do |p|
        if p.alive == false
          @players.delete(p)
          next
        end
        unless p.kind_of? Monster
          move = p.proxy.move
          m = move.first
          case m
          when :attack
            prep = " "
            o = move.last
            object = @players.select {|p|p.proxy == o}.first

            if object.nil?
              debugger
            end


            p.attack(object)
          when :rest
            p.rest
            prep = ""
            o = ""
          when :travel
            prep = " to "
          else
            prep = " with "
          end
          p "#{p.proxy} #{m}s#{prep}#{o}. #{p.stats}"
        end
      end
    end
    puts "Results:"
    @proxies.sort_by(&:to_s).each do |p|
      puts "#{p}: #{p.stats}"
    end
  end

  private
  
  def update_world
    self.class.world = { players: @proxies }
  end
end
