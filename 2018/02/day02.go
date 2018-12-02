package main

import (
	"bufio"
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

func main() {
	partOne()
}
