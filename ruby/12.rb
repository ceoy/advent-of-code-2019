#!/usr/bin/ruby

Vector3 = Struct.new(:x, :y, :z)

def part1(input, steps, debug)

  moons = parse_moons(input)

  # do 1000 steps
  # then calculate total energy
  (1..steps).each { |step|
    if debug
      puts "After #{step-1} steps:"
      puts moons
      puts
    end

    #apply gravity to update velocity
    moons.permutation(2).each { |pair|
      moon_one = pair[0]
      moon_two = pair[1]

      moon_one[:velocity].x += moon_two[:position].x <=> moon_one[:position].x
      moon_one[:velocity].y += moon_two[:position].y <=> moon_one[:position].y
      moon_one[:velocity].z += moon_two[:position].z <=> moon_one[:position].z
    }

    #apply velocity to position of moons
    moons.each { |moon|
      moon[:position].x += moon[:velocity].x
      moon[:position].y += moon[:velocity].y
      moon[:position].z += moon[:velocity].z
    }
  }
  if debug
    puts "After #{steps} steps:"
    puts moons
    puts
  end

  #calc total energy (pot energy * kinetic energy)
    #pot en = x.abs + y.abs + z.abs
    #kin en = velx.abs + vely.abs + velz.abs
  moons.map { |moon|
    pos = moon[:position]
    vel = moon[:velocity]
    potential_energy = pos.x.abs + pos.y.abs + pos.z.abs
    kinetic_energy = vel.x.abs + vel.y.abs + vel.z.abs
    potential_energy * kinetic_energy
  }.sum()

end

def part2(input)

  # https://www.reddit.com/r/adventofcode/comments/e9j0ve/2019_day_12_solutions/faja0lj/
  # lcm => least common multiple => lowest number that can be divided by each number
  moons = parse_moons(input)
  x_init = moons_ary.map { |moon| moon[0] }
  y_init = moons_ary.map { |moon| moon[1] }
  z_init = moons_ary.map { |moon| moon[2] }

  x_repeat = nil
  y_repeat = nil
  z_repeat = nil

  perm = moons.permutation(2)
  repeat = 0
  while x_repeat == nil or y_repeat == nil or z_repeat == nil

    repeat += 1

    #apply gravity to update velocity
    perm.each { |pair|
      moon_one = pair[0]
      moon_two = pair[1]

      moon_one[:velocity].x += moon_two[:position].x <=> moon_one[:position].x
      moon_one[:velocity].y += moon_two[:position].y <=> moon_one[:position].y
      moon_one[:velocity].z += moon_two[:position].z <=> moon_one[:position].z
    }

    #apply velocity to position of moons
    moons.each { |moon|
      moon[:position].x += moon[:velocity].x
      moon[:position].y += moon[:velocity].y
      moon[:position].z += moon[:velocity].z
    }

    # check for repeats
    # x_repeat
    if x_repeat == nil
      # velocity has to be 0
      if moons.all? { |moon| moon[:velocity].x == 0 } and
         moons[0][:position].x == x_init[0] and
         moons[1][:position].x == x_init[1] and
         moons[2][:position].x == x_init[2] and
         moons[3][:position].x == x_init[3]
        x_repeat = repeat
      end
    end
    if y_repeat == nil
      # velocity has to be 0
      if moons.all? { |moon| moon[:velocity].y == 0 } and
         moons[0][:position].y == y_init[0] and
         moons[1][:position].y == y_init[1] and
         moons[2][:position].y == y_init[2] and
         moons[3][:position].y == y_init[3]
        y_repeat = repeat
      end
    end
    if z_repeat == nil
      # velocity has to be 0
      if moons.all? { |moon| moon[:velocity].z == 0 } and
         moons[0][:position].z == z_init[0] and
         moons[1][:position].z == z_init[1] and
         moons[2][:position].z == z_init[2] and
         moons[3][:position].z == z_init[3]
        z_repeat = repeat

      end
    end
  end

  [x_repeat, y_repeat, z_repeat].reduce(1, :lcm)
end

def parse_moons(moon_data)
  moons=Array.new
  moon_data.each_line { |moon|
    c = moon.scan(/=([^,|>]*)/)
    position = Vector3.new(c[0].first.to_i, c[1].first.to_i, c[2].first.to_i)
    velocity = Vector3.new(0, 0, 0)
    moons.push({:position=>position, :velocity=>velocity})
  }
  moons
end

moon_data=File.open("../input/day12.txt").read
# moon_example_data=File.open("../input/day12.example.2.txt").read
puts part1(moon_data, 1000, false)
puts part2(moon_data)
