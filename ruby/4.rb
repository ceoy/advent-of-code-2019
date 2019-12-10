#!/usr/bin/ruby

require 'benchmark'

def part1()

  regex1 = /^0*1*2*3*4*5*6*7*8*9*$/
  regex2 = /([0-9])\1/

  occurences = 0
  (172851..675869).to_a.each { |number|
    if number.to_s.match(regex1) and number.to_s.match(regex2)
      occurences += 1
    end
  }

  occurences
end

def part2()

  regex1 = /^0*1*2*3*4*5*6*7*8*9*$/
  occurences = 0
  (172851..675869).to_a.each { |number|
    number=number.to_s

    if number.match(regex1)
      letters = Array.new(10, 0)
      number.each_char { |curr|
        letters[curr.to_i] += 1
      }
      valid=letters.any? { |n| n == 2 }
      if valid
        occurences += 1
      end
    end
  }

  occurences
end

r1=0
r2=0
Benchmark.bmbm do |x|
  x.report("part1") { r1=part1() }
  x.report("part2") { r2=part2() }
end

puts "\nResults:"
puts "day 4 part 1: #{r1}"
puts "day 4 part 2: #{r2}"
