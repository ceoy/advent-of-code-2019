package main

import (
	"fmt"
	"github.com/ceoy/advent-of-code-2019/go/library/util"
	"io/ioutil"
	"strings"
)

func inputToIntArray(input string) []int {
	stringArray := strings.FieldsFunc(input, util.SplitComma)
	intArray := []int{}
	for _, i := range stringArray {
		intArray = append(intArray, util.ConvertToInt(i))
	}
	return intArray
}

func part1(input string) int {
	a := inputToIntArray(input)
	a[1] = 12
	a[2] = 2

	instruction_pointer := 0
	for a[instruction_pointer] != 99 {
		opcode := a[instruction_pointer]

		if opcode == 1 {
			a[a[instruction_pointer+3]] = a[a[instruction_pointer+1]] + a[a[instruction_pointer+2]]
		} else if opcode == 2 {
			a[a[instruction_pointer+3]] = a[a[instruction_pointer+1]] * a[a[instruction_pointer+2]]
		}

		instruction_pointer += 4
	}
	return a[0]
}

func part2(input string) int {
	noun, verb, result := -1, 0, 0

	for result != 19690720 {
		a := inputToIntArray(input)
		noun += 1
		if noun >= len(a) {
			noun = 0
			verb += 1
		}

		a[1] = noun
		a[2] = verb

		instruction_pointer := 0

		for a[instruction_pointer] != 99 {
			opcode := a[instruction_pointer]

			if opcode == 1 {
				a[a[instruction_pointer+3]] = a[a[instruction_pointer+1]] + a[a[instruction_pointer+2]]
			} else if opcode == 2 {
				a[a[instruction_pointer+3]] = a[a[instruction_pointer+1]] * a[a[instruction_pointer+2]]
			}

			instruction_pointer += 4
		}
		result = a[0]
	}
	return 100*noun + verb
}

func main() {
	bytes, _ := ioutil.ReadFile("../../input/day2.txt")
	read_line := strings.TrimSuffix(string(bytes), "\n")

	resultPart1 := part1(read_line)
	fmt.Printf("part 1: %d\n", resultPart1)

	resultPart2 := part2(read_line)
	fmt.Printf("part 2: %d\n", resultPart2)
}
