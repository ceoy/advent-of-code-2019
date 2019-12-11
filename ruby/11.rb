#!/usr/bin/ruby

require 'benchmark'
require_relative 'intcode.rb'

Field = Struct.new(:painted, :color)

def solve(boost_program, init_color:0)
  modes = {:paint=>0, :turn=>1}
  facing = {:top=>0, :right=>1, :bottom=>2, :left=>3}
  colors = {:black=>0, :white=>1}
  turns = {:left=>0, :right=>1}

  # init intcode
  intcode = Intcode.new(boost_program)

  # intcode will input once, then output twice then repeat
  result = intcode.do_instruction(init_color)

  # init pane
  pane={}
  pane[0]={0=>Field.new(false, init_color)}

  # init position
  x_pos = 0
  y_pos = 0

  looking_at = facing[:top]
  current_mode = modes[:paint]

  while result != 99
    # make sure field exists
    if pane[y_pos] == nil
      pane[y_pos] = {}
    end
    if pane[y_pos][x_pos] == nil
      pane[y_pos][x_pos] = Field.new(false, colors[:black])
    end
    current_color = pane[y_pos][x_pos].color

    # get current field
    result = intcode.do_instruction(current_color)

    if result == 4 # output
      if current_mode == modes[:paint]
        pane[y_pos][x_pos].color = intcode.last_output
        pane[y_pos][x_pos].painted = true
        current_mode = modes[:turn]
      else # turn

        if intcode.last_output == turns[:left]
          looking_at -= 1
        else
          looking_at += 1
        end

        # make sure we dont move away
        if looking_at < facing[:top]
          looking_at = facing[:left]
        elsif looking_at > facing[:left]
          looking_at = facing[:top]
        end

        # move forward
        case looking_at
        when facing[:top]
          y_pos -= 1
        when facing[:right]
          x_pos += 1
        when facing[:bottom]
          y_pos += 1
        when facing[:left]
          x_pos -= 1
        end

        current_mode = modes[:paint]
      end
    end
  end
  pane
end

def part1(boost_program)
  pane = solve(boost_program)
  pane.map { |k,v| v.count  }.sum()
end

def part2(boost_program)
  pane = solve(boost_program, init_color:1)

  # fill
  min_y = pane.keys.min()
  max_y = pane.keys.max()
  min_x = pane.map { |k,v| v.keys.min() }.min()
  max_x = pane.map { |k,v| v.keys.max() }.max()

  (min_y..max_y).each { |h|
    if pane[h] == nil
      pane[h] = {}
    end
    (min_x..max_x).each { |w|
      if pane[h][w] == nil
        pane[h][w] = Field.new(false, 0)
      end
    }
  }

  (min_y..max_y).each { |y|
    (min_x..max_x).each { |x|
      if pane[y][x].color == 0
        print "."
      else
        print "#"
      end
    }
    puts
  }
end

boost=File.open("../input/day11.txt").read.split(",").map(&:to_i)

puts "Results:"
puts "Day 11 Part 1: #{part1(boost.dup)}"
puts "Day 11 Part 2:"
part2(boost.dup)
