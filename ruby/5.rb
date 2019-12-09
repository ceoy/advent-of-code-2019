#!/usr/bin/ruby

Result = Struct.new(:ip, :opcode, :a)

def do_instruction(ip, a, input)
  # https://www.alexstrick.com/blog/using-rubys-digits-method
  instruction = padleft(a[ip].digits.reverse, 5)
  opcode = instruction.last(2).join.to_i
  case opcode
  when 1 # add
    a[a[ip+3]]=getParamValue(a, ip, instruction, 1) + getParamValue(a, ip, instruction, 2)
    ip += 4
  when 2 # mul
    val = getParamValue(a, ip, instruction, 1) * getParamValue(a, ip, instruction, 2)
    a[a[ip+3]]=val
    ip += 4
  when 3 # input
    puts "require input - taking #{input}"
    a[a[ip+1]]=input # currenty hardcoded :)
    ip += 2
  when 4 # output
    value = getParamValue(a, ip, instruction, 1)
    puts value
    ip += 2
  when 5 # jmp if true
    if getParamValue(a, ip, instruction, 1) != 0
      ip = getParamValue(a, ip, instruction, 2)
    else
      ip += 3
    end
  when 6 # jmp if false
    if getParamValue(a, ip, instruction, 1) == 0
      ip = getParamValue(a, ip, instruction, 2)
    else
      ip += 3
    end
  when 7 # less than
    if getParamValue(a, ip, instruction, 1) < getParamValue(a, ip, instruction, 2)
      a[a[ip+3]]=1
    else
      a[a[ip+3]]=0
    end
    ip += 4
  when 8 # equals
    if getParamValue(a, ip, instruction, 1) == getParamValue(a, ip, instruction, 2)
      a[a[ip+3]]=1
    else
      a[a[ip+3]]=0
    end
    ip += 4
  when 99
    # program end
    puts "program finished"
  else
    puts "opcode #{opcode} not implemented"
  end

  Result.new(ip, opcode, a)
end

def getParamValue(a, ip, instruction, param)
  mode=instruction[3-param]
  if mode == 0 # position mode
    return a[a[ip+param]]
  elsif mode == 1 # immediate mode
    return a[ip+param]
  end
end


def padleft(a, n)
  Array.new([0, n-a.length].max, 0)+a
end

def part1(a)
  result=do_instruction(0, a, 1)
  while result.opcode != 99
    result=do_instruction(result.ip, result.a, 1)
  end
end

def part2(a, input)
  result=do_instruction(0, a, input)
  while result.opcode != 99
    result=do_instruction(result.ip, result.a, input)
  end
end

original=File.open("../input/day5.txt").read.split(",").map(&:to_i)
# example=File.open("../input/day5.example.7.txt").read.split(",").map(&:to_i)

part1(original.dup)
part2(original.dup, 5)
# part2(example.dup, 0)
