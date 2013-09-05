#!/usr/bin/env ruby
require 'debugger'

def require_dir(dir)
  Dir["#{dir}/*.rb"].each do |file|
    require File.join(File.dirname(__FILE__), file )
  end
end

require_dir("engine")

modules = []
ObjectSpace.each_object(Module) {|m| modules << m.name }
require_dir("players")
player_modules = []
ObjectSpace.each_object(Module) do |m| 
  next unless m.class == Module
  player_modules << m.name unless modules.include?(m.name)
end

require_dir("monsters")

game = Game.new

player_modules.each do |m|
  constant = Object
  player = Player.new
  game.players << player
  p = PlayerProxy.new(player)
  p.extend constant.const_get(m)
  player.proxy = p
  game.proxies << p
end

# Spawn 2 rats for each player
(game.players.count * 2).times do
  monster = Monster.new
  game.players << monster
  r = PlayerProxy.new(monster)
  r.extend Rat
  monster.proxy = r
  game.proxies << r
end

if ARGV.size > 1 and ARGV[0] == "-r" and ARGV[1] =~ /^[1-9]\d*$/
  ARGV.shift
  rount_count = ARGV.shift.to_i
else
  rount_count = 100
end

game.round(rount_count)
