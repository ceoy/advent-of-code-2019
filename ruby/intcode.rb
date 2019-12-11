#!/usr/bin/ruby

class Intcode
  def initialize(program, ip:0, base:0, last_output:nil, debug:false)
    @ip=ip
    @program=program
    @base=base
    @last_output=last_output
    @debug=debug
  end

  attr_reader :last_output

  def do_instruction(input)
    instruction = padleft(@program[@ip].digits.reverse, 5)
    opcode = instruction.last(2).join.to_i
    case opcode
    when 1 # add
      @program[getIndex(instruction, 3)]=getParamValue(instruction, 1) + getParamValue(instruction, 2)
      @ip += 4
    when 2 # mul
      @program[getIndex(instruction, 3)]=getParamValue(instruction, 1) * getParamValue(instruction, 2)
      @ip += 4
    when 3 # input
      @program[getIndex(instruction, 1)]=input
      if @debug
        puts "input is #{input}"
      end
      @ip += 2
    when 4 # output
      @last_output = getParamValue(instruction, 1)
      if @debug
        puts "output is #{@last_output}"
      end
      @ip += 2
    when 5 # jmp if true
      if getParamValue(instruction, 1) != 0
        @ip = getParamValue(instruction, 2)
      else
        @ip += 3
      end
    when 6 # jmp if false
      if getParamValue(instruction, 1) == 0
        @ip = getParamValue(instruction, 2)
      else
        @ip += 3
      end
    when 7 # less than
      if getParamValue(instruction, 1) < getParamValue(instruction, 2)
        @program[getIndex(instruction, 3)]=1
      else
        @program[getIndex(instruction, 3)]=0
      end
      @ip += 4
    when 8 # equals
      if getParamValue(instruction, 1) == getParamValue(instruction, 2)
        @program[getIndex(instruction, 3)]=1
      else
        @program[getIndex(instruction, 3)]=0
      end
      @ip += 4
    when 9 # adjust relative base
      @base += getParamValue(instruction, 1)
      @ip += 2

    when 99
      # program end
      if @debug
        puts "program finished"
      end
    else
      if @debug
        puts "opcode #{opcode} not implemented, cancelling"
      end
      opcode=99 # cancel program!
    end

    opcode
  end

  def getIndex(instruction, param)
    mode=instruction[3-param]
    if mode == 0 # position mode
      return @program[@ip+param] || 0
    elsif mode == 2 # relative mode
      return @program[@ip+param]+@base || 0
    end
  end

  def getParamValue(instruction, param)
    mode=instruction[3-param]
    if mode == 0 # position mode
      return @program[@program[@ip+param]] || 0
    elsif mode == 1 # immediate mode
      return @program[@ip+param] || 0
    elsif mode == 2 # relative mode
      return @program[@program[@ip+param]+@base] || 0
    end
  end


  def padleft(a, n)
    Array.new([0, n-a.length].max, 0)+a
  end
end
