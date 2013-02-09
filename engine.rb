#!/usr/bin/env ruby
def require_dir(dir)
  Dir["#{dir}/*.rb"].each do |file|
    require File.join(File.dirname(__FILE__), file )
  end
end

modules = []
ObjectSpace.each_object(Module) {|m| modules << m.name }
require_dir("players")
player_modules = []
ObjectSpace.each_object(Module) do |m| 
  player_modules << m.name unless modules.include?(m.name)
end
require_dir("engine")


# game = Game.new
if ARGV.size > 1 and ARGV[0] == "-r" and ARGV[1] =~ /^[1-9]\d*$/
  ARGV.shift
  rount_count = ARGV.shift.to_i
else
  rount_count = 10
end

# game.round(rount_count)

real_world = {
  name: "Freedonia",
  size: {
    x: 100,
    y: 100
  },
  number_of_players: 2
}

10.times do
  players = []
  player_modules.each do |m|
    player = Player.new
    players << player
    player.extend Object.const_get(m)
  end
  real_world[:players] = players.map(&:get_name)

  world = real_world.dup
  world.freeze

  LSpace.with(world: world) do
    players.each do |p|
      puts "#{p.get_name} #{p.get_move}"
    end
  end
end
puts "End " + $SAFE.to_s
