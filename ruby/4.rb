#!/usr/bin/ruby

file=File.open("../input/day4.txt").read
regex1 = /^0*1*2*3*4*5*6*7*8*9*$/
regex2 = /([0-9])\1/

occurences = 0
(172851..675869).to_a.each { |number|
  if number.to_s.match(regex1) and number.to_s.match(/([0-9])\1/)
    occurences += 1
  end
}

puts "day 4 part 1: #{occurences}"


occurences = 0
(172851..675869).to_a.each { |number|
  if number.to_s.match(regex1) and number.to_s.match(/([0-9])\1/)
    occurences += 1
  end
}

# puts "day 4 part 2: #{}"
