#!/usr/bin/ruby

# the program requires 2 inputs
# first will be 0
Result = Struct.new(:ip, :opcode, :a, :isInput, :output)

def do_instruction(ip, a, input)
  isInput=false
  output=nil
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
    #  puts "require input - taking #{input}"
    isInput=true
    a[a[ip+1]]=input
    ip += 2
  when 4 # output
    value = getParamValue(a, ip, instruction, 1)
    #puts value
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

  Result.new(ip, opcode, a, isInput, output)
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

def runAmplifier(program, index, digitsToTest, input)
  programToRun = program.dup # create a copy of the program
  digit=digitsToTest[index]

  result=do_instruction(0, programToRun, digit)

  while result.output == nil and result.opcode != 99
    result=do_instruction(result.ip, result.a, input)
  end
  result.output
end

def createArray()
  a=Array.new(3125)

  # mmh sexy
  index=0
  (0..4).each { |one|
    (0..4).each { |two|
      (0..4).each { |three|
        (0..4).each { |four|
          (0..4).each { |five|
            a[index]=[one, two, three, four, five]
            index+=1
          }
        }
      }
    }
  }
  return a.select { |number| number.uniq.length == 5 }
end

def part1(amplifier_controller_software)
  result=0
  createArray().each { |number|
    output=0
    for i in 0..4 do
      # run each amplifier
      output = runAmplifier(amplifier_controller_software, i, number, output)
    end
    if output != nil and result < output
      result = output
    end
  }
  result
end

program=File.open("../input/day7.txt").read.split(",").map(&:to_i)
#program=File.open("../input/day7.example.1.txt").read.split(",").map(&:to_i)
#program=File.open("../input/day7.example.2.txt").read.split(",").map(&:to_i)

puts "day 7 part 1: #{part1(program)}"
