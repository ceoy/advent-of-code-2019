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

	instructionPointer := 0
	for a[instructionPointer] != 99 {
		opcode := a[instructionPointer]

		if opcode == 1 {
			a[a[instructionPointer+3]] = a[a[instructionPointer+1]] + a[a[instructionPointer+2]]
		} else if opcode == 2 {
			a[a[instructionPointer+3]] = a[a[instructionPointer+1]] * a[a[instructionPointer+2]]
		}

		instructionPointer += 4
	}
	return a[0]
}

func part2(input string) int {
	noun, verb, result := -1, 0, 0

	for result != 19690720 {
		a := inputToIntArray(input)
		noun++
		if noun >= len(a) {
			noun = 0
			verb++
		}

		a[1] = noun
		a[2] = verb

		instructionPointer := 0

		for a[instructionPointer] != 99 {
			opcode := a[instructionPointer]

			if opcode == 1 {
				a[a[instructionPointer+3]] = a[a[instructionPointer+1]] + a[a[instructionPointer+2]]
			} else if opcode == 2 {
				a[a[instructionPointer+3]] = a[a[instructionPointer+1]] * a[a[instructionPointer+2]]
			}

			instructionPointer += 4
		}
		result = a[0]
	}
	return 100*noun + verb
}

func main() {
	bytes, _ := ioutil.ReadFile("../../input/day2.txt")
	readLine := strings.TrimSuffix(string(bytes), "\n")

	resultPart1 := part1(readLine)
	fmt.Printf("part 1: %d\n", resultPart1)

	resultPart2 := part2(readLine)
	fmt.Printf("part 2: %d\n", resultPart2)
}
