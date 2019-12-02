#!/usr/bin/ruby

fuel=0
file=File.open("../input/day1.txt").read
file.each_line do |line|
  fuel += line.to_i / 3 - 2
end

puts "part 1 fuel is: #{fuel}"

def calcFuel(mass)
  fuel=mass.to_i / 3 - 2
  if fuel < 0
    return 0
  end

  fuel+=calcFuel(fuel)
end

fuel_p2=0
file.each_line do |mass|
  fuel_p2 += calcFuel(mass.to_i)
end
puts "part 2 fuel is: #{fuel_p2}"
