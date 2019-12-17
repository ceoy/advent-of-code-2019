#!/usr/bin/ruby

require_relative 'intcode.rb'

Tile = Struct.new(:x, :y, :id)

def solve(source_code)
  # init intcode
  intcode = Intcode.new(source_code)

  # intcode will input once, then output twice then repeat
  result = intcode.do_instruction(0)

  tiles=Array.new

  current_tile_progress=0

  while result != 99

    # get current field
    result = intcode.do_instruction(1)

    if result == 4 # output
      case current_tile_progress
      when 0
        tile = Tile.new(intcode.last_output)
        tiles.push(tile)
        current_tile_progress = 1
      when 1
        tiles.last().y = intcode.last_output
        current_tile_progress = 2
      when 2
        tiles.last().id = intcode.last_output
        current_tile_progress = 0
      end
    end
  end

  tiles
end

def part1(code)
 tiles = solve(code)
 tiles.count { |tile| tile.id == 2 }
end

def part2(code)
  code[0] = 2
  tiles = solve(code)
  tiles.count { |tile| tile.id == 3 }
end

arcade_cabinet_source=File.open("../input/day13.txt").read.split(",").map(&:to_i)

puts "Results:"
puts "Day 13 Part 1: #{part1(arcade_cabinet_source.dup)}"
puts "Day 13 Part 2: #{part2(arcade_cabinet_source.dup)}"
