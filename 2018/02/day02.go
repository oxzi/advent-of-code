package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
)

func linewiseInput(filename string) []string {
	var buff []string

	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		buff = append(buff, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	return buff
}

func strToOccurrenceMap(str string) map[rune]uint {
	occurrenceMap := make(map[rune]uint)

	for _, c := range str {
		if i, ok := occurrenceMap[c]; ok {
			occurrenceMap[c] = i + 1
		} else {
			occurrenceMap[c] = 1
		}
	}

	return occurrenceMap
}

func strRuneCompare(str1, str2 string) (diffs uint, same string, err error) {
	diffs = 0
	same = ""

	if len(str1) != len(str2) {
		err = errors.New("strings differ in length")
		return
	}

	for i, c := range str1 {
		if str1[i] == str2[i] {
			same += string(c)
		} else {
			diffs += 1
		}
	}

	return
}

func partOne() {
	var twos, threes uint = 0, 0

	lines := linewiseInput("input")
	for _, l := range lines {
		chkTwos, chkThress := true, true
		occ := strToOccurrenceMap(l)

		for _, v := range occ {
			if v == 3 && chkThress {
				threes += 1
				chkThress = false
			} else if v == 2 && chkTwos {
				twos += 1
				chkTwos = false
			}
		}
	}

	fmt.Println("--- Part One ---")
	fmt.Printf("Result: %d * %d = %d\n\n", twos, threes, twos*threes)
}

func partTwo() {
	lines := linewiseInput("input")

	fmt.Println("--- Part Two ---")

	for i := 0; i < len(lines); i++ {
		for j := 0; j < i; j++ {
			diffs, same, err := strRuneCompare(lines[i], lines[j])
			if err != nil {
				panic(err)
			}

			if diffs == 1 {
				fmt.Printf("%v and %v differ only by once,\nresulting in %v\n\n",
					lines[i], lines[j], same)
				return
			}
		}
	}

	fmt.Println("Found nothing ;_;")
}

func main() {
	partOne()
	partTwo()
}
