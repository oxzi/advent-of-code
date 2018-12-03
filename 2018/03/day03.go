package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func linewiseInput(filename string, ch chan<- string) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		ch <- scanner.Text()
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	close(ch)
}

type Coordinate struct {
	x int
	y int
}

func (c Coordinate) String() string {
	return fmt.Sprintf("(%d, %d)", c.x, c.y)
}

type Claim struct {
	id     int
	x      int
	y      int
	width  int
	height int
}

func NewClaim(str string) *Claim {
	re := regexp.MustCompile(`^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$`)
	m := re.FindStringSubmatch(str)

	id, _ := strconv.Atoi(m[1])
	x, _ := strconv.Atoi(m[2])
	y, _ := strconv.Atoi(m[3])
	width, _ := strconv.Atoi(m[4])
	height, _ := strconv.Atoi(m[5])

	return &Claim{id, x, y, width, height}
}

func (c Claim) String() string {
	return fmt.Sprintf("#%d @ %d,%d: %dx%d",
		c.id, c.x, c.y, c.width, c.height)
}

func (c Claim) ToCoordinates() []*Coordinate {
	cords := make([]*Coordinate, 0)

	for y := c.y; y < c.y+c.height; y++ {
		for x := c.x; x < c.x+c.width; x++ {
			cords = append(cords, &Coordinate{x, y})
		}
	}

	return cords
}

func (c1 Claim) Intersect(c2 Claim) (*Claim, error) {
	overlap_c1_x := (c2.x <= c1.x && c1.x <= c2.x+c2.width)
	overlap_c2_x := (c1.x <= c2.x && c2.x <= c1.x+c1.width)

	overlap_c1_y := (c2.y <= c1.y && c1.y <= c2.y+c2.height)
	overlap_c2_y := (c1.y <= c2.y && c2.y <= c1.y+c1.height)

	if !((overlap_c1_x || overlap_c2_x) && (overlap_c1_y || overlap_c2_y)) {
		return nil, errors.New("Claims are not overlapping")
	}

	var x, y, width, height int

	if overlap_c1_x {
		x = c1.x
	} else {
		x = c2.x
	}

	if overlap_c1_y {
		y = c1.y
	} else {
		y = c2.y
	}

	if c1.x+c1.width < c2.x+c2.width {
		width = c1.x + c1.width - x
	} else {
		width = c2.x + c2.width - x
	}

	if c1.y+c1.height < c2.y+c2.height {
		height = c1.y + c1.height - y
	} else {
		height = c2.y + c2.height - y
	}

	if width == 0 || height == 0 {
		return nil, errors.New("Claims are just touching")
	}

	return &Claim{0, x, y, width, height}, nil
}

func PartOne() {
	ch := make(chan string)
	go linewiseInput("input", ch)

	claims := make([]*Claim, 0)
	for l := range ch {
		claims = append(claims, NewClaim(l))
	}

	coordinates := make(map[Coordinate]bool)

	for i := 0; i < len(claims); i++ {
		for j := i + 1; j < len(claims); j++ {
			ci, err := claims[j].Intersect(*claims[i])
			if err != nil {
				continue
			}

			coords := ci.ToCoordinates()
			for _, coord := range coords {
				coordinates[*coord] = true
			}
		}
	}

	fmt.Println("--- Part One ---")
	fmt.Printf("Overlapping coordinates: %d\n\n", len(coordinates))
}

func main() {
	PartOne()
}
