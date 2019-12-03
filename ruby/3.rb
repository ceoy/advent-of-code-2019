#!/usr/bin/ruby

file=File.open("../input/day3.txt").read

map={}
map[0]={}
map[0][0]='o'
shortestPath=1000000000000

currentWire = 0
file.each_line do |wire|
  x = 0
  y = 0

  currentWire += 1
  wire.split(",").each { |direction|
    dir = direction[0]
    direction[0] = ''
    (1..direction.to_i).to_a.each {

      case dir
      when "R"
        x += 1
      when "U"
        y += 1
      when "D"
        y -= 1
      when "L"
        x -= 1
      end

      if map[x] == nil
        map[x] = {}
      end

      if map[x][y] != nil and map[x][y] != currentWire and map[x][y] != 'o'
        # calculate distance to 0, 0
        distance = (x).abs + (y).abs
        if distance < shortestPath
          shortestPath = distance
        end
      end
      map[x][y]=currentWire
    }
  }
end

puts "day 3 part 1: #{shortestPath}"

# reset and start with part 2
map={}
map[0]={}
map[0][0]='o'
shortestPath=1000000000000

currentWire = 0
file.each_line do |wire|
  x = 0
  y = 0

  currentWire += 1
  currentStep = 0
  wire.split(",").each { |direction|
    dir = direction[0]
    direction[0] = ''

    (1..direction.to_i).to_a.each {
      currentStep += 1

      case dir
      when "R"
        x += 1
      when "U"
        y += 1
      when "D"
        y -= 1
      when "L"
        x -= 1
      end

      if map[x] == nil
        map[x] = {}
      end
      if map[x][y] == nil
        map[x][y] = {}
      end

      if map[x][y][currentWire] == nil
        # if we have been here before, the way must be shorter
        map[x][y][currentWire]=currentStep
      end


      if map[x][y].length > 1
        m = map[x][y]

        key = m.keys[m.find_index { |_,i| i != currentWire }]
        distance = m[key] + currentStep
        puts distance

        if distance < shortestPath
          shortestPath = distance
        end
      end
    }
  }
end

puts "day 3 part 2: #{shortestPath}"


