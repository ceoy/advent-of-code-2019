#!/usr/bin/ruby

# the program requires 2 inputs
# first will be 0
Result = Struct.new(:ip, :opcode, :a, :output)

AmplifierRun = Struct.new(:output, :done)

class Amplifier < Struct.new(:program_to_run, :result)
  def run(input)
    loop do
      self.result = do_instruction(self.result.ip, self.result.a, input)
      if self.result.opcode == 99 or self.result.output != nil
        break
      end
    end

    return AmplifierRun.new(self.result.output, self.result.opcode == 99)
  end
end


def do_instruction(ip, a, input)
  output=nil
  instruction = padleft(a[ip].digits.reverse, 5)
  opcode = instruction.last(2).join.to_i
  case opcode
  when 1 # add
    a[a[ip+3]]=getParamValue(a, ip, instruction, 1) + getParamValue(a, ip, instruction, 2)
    ip += 4
  when 2 # mul
    a[a[ip+3]]=getParamValue(a, ip, instruction, 1) * getParamValue(a, ip, instruction, 2)
    ip += 4
  when 3 # input
    a[a[ip+1]]=input
    ip += 2
  when 4 # output
    value = getParamValue(a, ip, instruction, 1)
    output = value
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
    puts "opcode #{opcode} not implemented, cancelling"
    opcode=99 # cancel program!
  end

  Result.new(ip, opcode, a, output)
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

def initAmplifier(program, init_input)
  program_to_run = program.dup
  # first is still an input
  result=do_instruction(0, program_to_run, init_input)

  return Amplifier.new(program_to_run, result)
end

def feedback_loop_array()
  return [*5..9].permutation(5)
end

def part2(amplifier_controller_software)
  high=0
  feedback_loop_array().each { |number|
    amplifiers=Array.new(5)
    for amplifier_index in 0..4 do # init amplifiers
      amplifiers[amplifier_index] = initAmplifier(amplifier_controller_software, number[amplifier_index])
    end

    amplifier_index=0
    last_output=0

    result = amplifiers[amplifier_index].run(0)

    while !result.done
      amplifier_index += 1
      if amplifier_index > 4
        amplifier_index=0
      end
      last_output = result.output
      result = amplifiers[amplifier_index].run(result.output)
    end
    if high < last_output
      high = last_output
    end
  }
  high
end

program=File.open("../input/day7.txt").read.split(",").map(&:to_i)
#program=File.open("../input/day7.example.3.txt").read.split(",").map(&:to_i)
#program=File.open("../input/day7.example.2.txt").read.split(",").map(&:to_i)

puts "day 7 part 2: #{part2(program)}"
