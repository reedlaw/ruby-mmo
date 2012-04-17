#!/usr/bin/env ruby
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on("-r", "--runs N", Integer, "Number of runs") do |runs|
    options[:runs] = runs
  end
  opts.on("-o", "--rounds N", Integer, "Number of rounds") do |rounds|
    options[:rounds] = rounds
  end
end.parse!

options[:runs] = 1000 unless options[:runs]
options[:rounds] = 10 unless options[:rounds]

last_line = []

options[:runs].times do
  output = `ruby ./engine.rb -r #{options[:rounds]}`
  last_line.push output.split("\n").last
end

winners = Hash.new(0)

last_line.each do |val|
  winners[val] += 1
end

winners.sort_by{|winner, times| -times}.each do |winner, times|
  puts "#{winner.gsub(' is the winner!', '')} won #{times} times"
end
