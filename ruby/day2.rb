#!/usr/bin/ruby

original=File.open("../input/day2.txt").read.split(",").map(&:to_i)
a = original.dup
a[1] = 12
a[2] = 2

position = 0
while a[position] != 99
  opcode = a[position]

  if opcode == 1
    # add
    a[a[position+3]]=a[a[position+1]]+a[a[position+2]]
  elsif opcode == 2
    # mul
    a[a[position+3]]=a[a[position+1]]*a[a[position+2]]
  end

  position += 4
end


puts "part 1: #{a[0]}"

def calc(a, noun, verb)
  a[1] = noun
  a[2] = verb

  instruction_pointer=0
  while a[instruction_pointer] != 99
    instruction = a[instruction_pointer]

    if instruction == 1
      # add
      a[a[instruction_pointer+3]]=a[a[instruction_pointer+1]]+a[a[instruction_pointer+2]]
    elsif instruction == 2
      # mul
      a[a[instruction_pointer+3]]=a[a[instruction_pointer+1]]*a[a[instruction_pointer+2]]
    end

    instruction_pointer += 4
  end

  a[0]
end

result=0
noun=-1 # so it will increase to 1 in the first entry
verb=0
max_length=original.length # dont need to increase above that, you wont find a value anyways
while result != 19690720

  # reset :)
  noun += 1
  if noun >= max_length
    noun = 0
    verb += 1
  end

  a = original.dup
  result = calc(a, noun, verb)

end

puts "day2: #{100 * noun + verb}"
