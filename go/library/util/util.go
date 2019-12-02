package util

import (
	"strconv"
)

func SplitNewline(c rune) bool {
	return c == '\n'
}

func SplitComma(c rune) bool {
	return c == ','
}

func ConvertToInt(s string) int {
	i, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	return i
}
