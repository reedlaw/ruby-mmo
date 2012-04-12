#!/usr/bin/env ruby

last_line = []

1000.times do
  output = `ruby ./engine.rb`
  last_line.push output.split("\n").last
end

winners = Hash.new(0)

last_line.each do |val|
  winners[val] += 1
end

winners.sort_by{|winner, times| -times}.each do |winner, times|
  puts "#{winner.gsub(' is the winner!', '')} won #{times} times"
end
