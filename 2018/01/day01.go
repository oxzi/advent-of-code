package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func readInput(filename string, c chan<- int) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		numb_str := scanner.Text()
		if numb, err := strconv.Atoi(numb_str); err == nil {
			c <- numb
		}
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	close(c)
}

func infiniteChannel(input <-chan int, output chan<- int) {
	var buff []int
	for i := range input {
		buff = append(buff, i)
		output <- i
	}

	for i := 0; ; i++ {
		if i == len(buff) {
			i = 0
		}

		output <- buff[i]
	}
}

func infiniteInput(filename string, c chan<- int) {
	ch := make(chan int)
	go readInput("input", ch)
	go infiniteChannel(ch, c)
}

func partOne() {
	c := make(chan int)
	go readInput("input", c)

	sum := 0
	for i := range c {
		sum += i
	}

	fmt.Println("--- Part One ---")
	fmt.Printf("Sum of input is %d\n\n", sum)
}

func partTwo() {
	c := make(chan int)
	go infiniteInput("input", c)

	sum := 0
	sums := make(map[int]bool)

	for i := range c {
		sums[sum] = true

		sum += i
		if _, ok := sums[sum]; ok {
			break
		}
	}

	fmt.Println("--- Part Two ---")
	fmt.Printf("First resulting frequency is %d\n\n", sum)
}

func main() {
	partOne()
	partTwo()
}
