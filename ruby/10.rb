#!/usr/bin/ruby

class Vector < Struct.new(:x, :y, :deleted)
  def angle_between(vector_b)
    m_x=vector_b.x-self.x
    m_y=vector_b.y-self.y
    Math.atan2(m_y, m_x) * 180 / Math::PI + 180 # to have 0-360 degree # care

  end

  def distance_between(vector_b)
    x=(vector_b.x-self.x)**2
    y=(vector_b.y-self.y)**2
    Math.sqrt(x+y)
  end
end

def parseAsteroids(file)
  asteroids=Array.new
  y=0
  File.open(file).read.each_line do |line|
    x=0
    line.split("").each do |type|
      if type == '#'
        # its an astroid
        asteroids.push(Vector.new(x,y,false))
      end
      x += 1
    end
    y += 1
  end
  return asteroids
end

def part1()
  asteroids=parseAsteroids("../input/day10.txt")
  asteroids.map { |asteroid|
    distances={}
    # calculate distance between each point
    asteroids.map { |asteroid_compare|
      if asteroid.x == asteroid_compare.x and asteroid.y == asteroid_compare.y
        next
      end

      distances[asteroid.angle_between(asteroid_compare)]=asteroid_compare
    }
    distances.count
  }.max
end


require 'pp'

def part2()
  asteroids=parseAsteroids("../input/day10.txt")

  # find monitoring station
  asteroid_index = asteroids.map { |asteroid|
    distances={}
    asteroids.map { |asteroid_compare|
      if asteroid.x == asteroid_compare.x and asteroid.y == asteroid_compare.y
        next
      end

      distances[asteroid.angle_between(asteroid_compare)]=asteroid_compare
    }
    distances.count
  }.each_with_index.max[1]
  vaporizer_position=asteroids[asteroid_index]

  # prepare data
  asteroid_finder={}
  asteroids.each { |poor_asteroid|
    if vaporizer_position.x == poor_asteroid.x and vaporizer_position.y == poor_asteroid.y
      next
    end
    angle = vaporizer_position.angle_between(poor_asteroid)
    if asteroid_finder[angle] == nil
      asteroid_finder[angle]={}
    end

    distance = vaporizer_position.distance_between(poor_asteroid)
    asteroid_finder[angle][distance] = poor_asteroid
  }
  asteroid_finder.each_with_index { |value, index|
    key=asteroid_finder.keys[index]
    asteroid_finder[key] = asteroid_finder[key].sort_by { |k, v| k }.to_h
  }


  asteroid_finder = asteroid_finder.sort_by { |k, v| k }.to_h
  currentRotationIndex = asteroid_finder.find_index { |k,i|  k == 90.0 }
  asteroid_finder = asteroid_finder.values

  vaporized=nil
  (1..200).each { |number|
    deleted=false
    while !deleted
      asteroid = asteroid_finder[currentRotationIndex].values.find { |v| !v.deleted }
      if asteroid != nil
        asteroid.deleted = true
        deleted=true
        vaporized=asteroid
      end

      currentRotationIndex += 1
      if currentRotationIndex >= asteroid_finder.length
        currentRotationIndex = 0
      end
    end
  }
  vaporized.x * 100 + vaporized.y
end

puts part1()
puts part2()
