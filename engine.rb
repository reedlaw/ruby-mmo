#!/usr/bin/env ruby
require 'debugger'
require 'ruby_cop'

def safe_require_dir(dir)
  policy = RubyCop::Policy.new
  Dir["#{dir}/*.rb"].each do |file|
    fn = File.join(File.dirname(__FILE__), file)
    f = File.open(fn, "r")
    ast = RubyCop::NodeBuilder.build(f.read)
    if ast.accept(policy)
      require fn
      puts "#{fn} loaded"
    else
      puts "#{fn} not allowed!"
    end
  end
end

def require_dir(dir)
  Dir["#{dir}/*.rb"].each do |file|
    require File.join(File.dirname(__FILE__), file)
  end
end

# Load players
modules = []
ObjectSpace.each_object(Module) {|m| modules << m.name }
safe_require_dir("players")
player_modules = []
ObjectSpace.each_object(Module) do |m| 
  player_modules << m.name unless modules.include?(m.name)
end
# Remove the safe_send method from player modules to prevent cheating
player_modules.each do |m|
  modjule = Object.const_get(m)
  if modjule.method_defined? :safe_send
    modjule.module_eval do
      remove_method :safe_send
    end
  end
end

require 'lspace/celluloid'
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
    Celluloid::Actor[m.to_sym] = player
  end
  real_world[:players] = players.map{|p| p.safe_send(:name)}

  world = real_world.dup
  world.freeze

  LSpace.with(world: world) do
    players.each do |p|
      puts "#{p.safe_send(:name)} #{p.safe_send(:move)}"
    end
  end
end
puts "End " + $SAFE.to_s
