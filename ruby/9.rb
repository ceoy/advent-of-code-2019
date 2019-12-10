#!/usr/bin/ruby

require 'benchmark'

class Intcode < Struct.new(:ip, :program, :base, :last_output)

  def do_instruction(input)
    instruction = padleft(self.program[self.ip].digits.reverse, 5)
    opcode = instruction.last(2).join.to_i
    case opcode
    when 1 # add
      self.program[getIndex(instruction, 3)]=getParamValue(instruction, 1) + getParamValue(instruction, 2)
      self.ip += 4
    when 2 # mul
      self.program[getIndex(instruction, 3)]=getParamValue(instruction, 1) * getParamValue(instruction, 2)
      self.ip += 4
    when 3 # input
      self.program[getIndex(instruction, 1)]=input
      self.ip += 2
    when 4 # output
      self.last_output = getParamValue(instruction, 1)
      self.ip += 2
    when 5 # jmp if true
      if getParamValue(instruction, 1) != 0
        self.ip = getParamValue(instruction, 2)
      else
        self.ip += 3
      end
    when 6 # jmp if false
      if getParamValue(instruction, 1) == 0
        self.ip = getParamValue(instruction, 2)
      else
        self.ip += 3
      end
    when 7 # less than
      if getParamValue(instruction, 1) < getParamValue(instruction, 2)
        self.program[getIndex(instruction, 3)]=1
      else
        self.program[getIndex(instruction, 3)]=0
      end
      self.ip += 4
    when 8 # equals
      if getParamValue(instruction, 1) == getParamValue(instruction, 2)
        self.program[getIndex(instruction, 3)]=1
      else
        self.program[getIndex(instruction, 3)]=0
      end
      self.ip += 4
    when 9 # adjust relative base
      self.base += getParamValue(instruction, 1)
      self.ip += 2

    when 99
      # program end
      puts "program finished"
    else
      puts "opcode #{opcode} not implemented, cancelling"
      opcode=99 # cancel program!
    end

    opcode
  end

  def getIndex(instruction, param)
    mode=instruction[3-param]
    if mode == 0 # position mode
      return self.program[self.ip+param] || 0
    elsif mode == 2 # relative mode
      return self.program[self.ip+param]+self.base || 0
    end
  end

  def getParamValue(instruction, param)
    mode=instruction[3-param]
    if mode == 0 # position mode
      return self.program[self.program[self.ip+param]] || 0
    elsif mode == 1 # immediate mode
      return self.program[self.ip+param] || 0
    elsif mode == 2 # relative mode
      return self.program[self.program[self.ip+param]+self.base] || 0
    end
  end


  def padleft(a, n)
    Array.new([0, n-a.length].max, 0)+a
  end
end

def part1(boost_program)
  intcode = Intcode.new(0, boost_program, 0)
  result = intcode.do_instruction(1)
  while result != 99
    result = intcode.do_instruction(1)
  end

  intcode.last_output
end

def part2(boost_program)
  intcode = Intcode.new(0, boost_program, 0)
  result = intcode.do_instruction(2)
  while result != 99
    result = intcode.do_instruction(2)
  end

  intcode.last_output
end

boost=File.open("../input/day9.txt").read.split(",").map(&:to_i)

r1=0
r2=0
Benchmark.bmbm do |x|
  x.report("part1") { r1=part1(boost.dup) }
  x.report("part2") { r2=part2(boost.dup) }
end

puts "\nResults:"
puts "Day 9 Part 1: #{r1}"
puts "Day 9 Part 2: #{r2}"
