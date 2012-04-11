#!/usr/bin/env ruby
require 'debugger'



#This creates the require_dir method that is used for requiring the engine, players, and monsters directories below
def require_dir(dir)
  Dir["#{dir}/*.rb"].each do |file|
    require File.join(File.dirname(__FILE__), file )
  end
end


#This requires the engine directory
require_dir("engine")



#I don't know what this does
modules = []
ObjectSpace.each_object(Module) {|m| modules << m.name } #Traverses all objects that are modules or subclasses of modules
                                                         #And adds them to the modules array

require_dir("players")
player_modules = []
ObjectSpace.each_object(Module) do |m| 
  player_modules << m.name unless modules.include?(m.name)
end


#IThis imports the monsters directory
require_dir("monsters")


#This creates a new Game object
game = Game.new



player_modules.each do |m|
  constant = Object
  player = Player.new
  game.players << player   #adds each player to the game's player array


  p = PlayerProxy.new(player)  #I'm not sure what the player proxy is
  p.extend constant.const_get(m)
  player.proxy = p
  game.proxies << p
end


#This generates new monsters
10.times do
  monster = Monster.new
  game.players << monster
  r = PlayerProxy.new(monster)
  r.extend Rat
  monster.proxy = r
  game.proxies << r
end


#Rreceive the round count, and does something with a regex for any other command line arguments
if ARGV.size > 1 and ARGV[0] == "-r" and ARGV[1] =~ /^[1-9]\d*$/
  ARGV.shift
  rount_count = ARGV.shift.to_i
else
  rount_count = 10
end



#This iterates the rounds
game.round(rount_count)
