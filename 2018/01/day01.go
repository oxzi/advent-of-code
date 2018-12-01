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

func main() {
	c := make(chan int)
	go readInput("input", c)

	sum := 0
	for i := range c {
		sum += i
	}

	fmt.Printf("Sum of input is %d\n", sum)
}
