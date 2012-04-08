#!/usr/bin/env ruby
require 'debugger'

class Player
  attr_accessor :proxy, :health

  def initialize
    @health = 100
    @level = 0
    @strength = 20
    @defense = 10
    @experience = 0
  end

  def fight(opponent)
    @health = @health - 2
    if opponent.class != Player
      raise "Nice try, but no cheating!"
    else
      opponent.health = opponent.health - 5
    end
  end

  def stats
    { health: @health, level: @level, strength: @strength, defense: @defense }
  end
end

class PlayerProxy
  def initialize(player)
    @player = player
  end

  def method_missing(method, *args, &block)
    if [:move, :fight, :to_s, :trade, :rest, :inspect, :stats].include? method
      @player.send(method, *args, &block)
    end
  end
end

class Game
  attr_reader :players, :proxies

  class << self
    attr_accessor :world
  end

  def initialize
    @players = []
    @proxies = []
  end
  
  def turn(rounds)
    update_world
    rounds.times do |i|
      p "Round #{i}"
      @players.each do |p|
        m = p.proxy.move.first
        o = p.proxy.move.last
        object = @players.select {|p|p.proxy == o}.first
        case m
        when :fight
          prep = "with"
          p.fight(object)
        when :travel
          prep = "to"
        else
          prep = "with"
        end
        p "#{p} #{m}s #{prep} #{o}"
      end
    end
    @players.each do |p|
      puts "#{p}: #{p.stats}"
    end
  end

  private
  
  def update_world
    self.class.world = { players: @proxies }
  end
end

modules = []
ObjectSpace.each_object(Module) {|m| modules << m.name }

Dir["players/*.rb"].each do |file|
  require File.join(File.dirname(__FILE__), file )
end

added_modules = []
ObjectSpace.each_object(Module) {|m| added_modules << m.name unless modules.include?(m.name) }

game = Game.new

added_modules.each do |m|
  constant = Object
  player = Player.new
  game.players << player
  p = PlayerProxy.new(player)
  p.extend constant.const_get(m)
  player.proxy = p
  game.proxies << p
end

game.turn(3)
