package main

import (
	"fmt"
	"github.com/ceoy/advent-of-code-2019/go/library/util"
	"io/ioutil"
	"strings"
)

func part1(input string) int {
	fuel := 0

	for _, mass := range strings.FieldsFunc(input, util.SplitNewline) {
		fuel += util.ConvertToInt(mass)/3 - 2
	}
	return fuel
}

func part2(input string) int {
	totalFuel := 0
	for _, mass := range strings.FieldsFunc(input, util.SplitNewline) {
		fuel := util.ConvertToInt(mass)/3 - 2
		for fuel > 0 {
			totalFuel += fuel
			fuel = fuel/3 - 2
		}
	}
	return totalFuel
}

func main() {
	bytes, _ := ioutil.ReadFile("../../input/day1.txt")

	resultPart1 := part1(string(bytes))
	fmt.Printf("part 1 fuel is: %d\n", resultPart1)

	resultPart2 := part2(string(bytes))
	fmt.Printf("part 2 fuel is: %d\n", resultPart2)
}
