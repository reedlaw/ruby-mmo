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
      puts "Round #{i}"
      update_world

      # Step #1: Collect moves
      rest = Array.new
      attacks = Hash.new
      @players.each do |p|
        unless p.kind_of? Monster
          move = p.proxy.move
          # p "#{p.proxy.move}"
          # p p.proxy.to_s
          # p "move"
          # p move
          m = move.first
          case m
          when :attack
            o = move.last
            object = @players.select {|p| p.proxy == o}.first

            # prevent using not existing objects
            if object
              attacks[object] = [] unless attacks.keys.include? object
              attacks[object] << p
            end
          when :rest
            rest << p
          end
        end
      end

      # Setp #2: Rest players
      rest.each do |p|
        p.rest(nil)
        puts "#{p.proxy} rests"
      end

      # Step #3: Attacks

      # Sort attacks by the size of the groups,
      # i.e. larger groups attack first, other is random
      attacks = attacks.to_a.sort_by { |target, attackers| [ -attackers.size, rand()] }
      
      attacks.each do |target, attackers|
        # filter only alive attackers
        attackers = attackers.select {|a| a.alive}

        if attackers.empty?
          next
        elsif attackers.length == 1
          puts "#{attackers.first.proxy} attacks #{target.proxy}"
        else
          puts "#{attackers[0..-2].map {|a| a.proxy}.join ', '} and #{attackers.last.proxy} attack #{target.proxy}"
        end

        attackers.each do |attacker|
          attacker.attack(target)
          break unless target.alive
        end

        if not target.alive
          attackers.each { |attacker| attacker.reward(target, attackers.size) }
          @players.delete(target)
          @proxies.delete(target.proxy)
        end
      end

      # Finish if there is only one player
      break if @players.size == 1

      # Print stats
      puts "Stats:"
      @proxies.sort_by { |p| [-p.stats[:experience], p.to_s] }.each do |p|
        puts "\t#{p}: #{p.stats}"
      end
      puts 

    end
    puts 
    puts "Results:"
    puts "--------"
    @proxies.sort_by { |p| [-p.stats[:experience], p.to_s] }.each do |p|
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
