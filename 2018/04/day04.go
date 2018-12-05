package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
)

type Action int

const (
	BeginsShift Action = iota
	FallsAsleep Action = iota
	WakesUp     Action = iota
)

type LogEntry struct {
	timestamp time.Time
	guardNo   int
	action    Action
}

func (le LogEntry) String() string {
	var actionStr string
	switch le.action {
	case BeginsShift:
		actionStr = fmt.Sprintf("Guard #%d begins shift", le.guardNo)
	case FallsAsleep:
		actionStr = "falls asleep"
	case WakesUp:
		actionStr = "wakes up"
	}

	return fmt.Sprintf("[%v] %s", le.timestamp, actionStr)
}

func NewLogEntry(str string) (le LogEntry) {
	re_time := regexp.MustCompile(`^\[(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2})\]`)
	mt := re_time.FindStringSubmatch(str)

	year, _ := strconv.Atoi(mt[1])
	month, _ := strconv.Atoi(mt[2])
	day, _ := strconv.Atoi(mt[3])
	hour, _ := strconv.Atoi(mt[4])
	min, _ := strconv.Atoi(mt[5])

	le.timestamp = time.Date(
		year, time.Month(month), day, hour, min, 0, 0, time.UTC)

	if strings.HasSuffix(str, "falls asleep") {
		le.action = FallsAsleep
	} else if strings.HasSuffix(str, "wakes up") {
		le.action = WakesUp
	} else {
		le.action = BeginsShift

		re_guard_no := regexp.MustCompile(`Guard #(\d+) begins shift$`)
		mg := re_guard_no.FindStringSubmatch(str)

		guard_no, _ := strconv.Atoi(mg[1])
		le.guardNo = guard_no
	}

	return
}

type Guard struct {
	no      int
	entries []LogEntry
}

func (g Guard) String() string {
	return fmt.Sprintf("#%d, (%v)", g.no, g.entries)
}

func (g Guard) SleepTime() (asleepMins, sleepyMin, sleepyMinOccu int) {
	var (
		asleepSec int64 = 0
		sleepSecs int64 = 0

		mins = make([]int, 60)
	)

	for _, le := range g.entries {
		switch le.action {
		case FallsAsleep:
			asleepSec = le.timestamp.Unix()

		case WakesUp:
			sleepSecs += le.timestamp.Unix() - asleepSec

			oldTime := time.Unix(asleepSec, 0).In(time.UTC)
			for i := oldTime.Minute(); i < le.timestamp.Minute(); i++ {
				mins[i] += 1
			}
		}
	}

	asleepMins = int(sleepSecs / 60)

	for i := 1; i < len(mins); i++ {
		if mins[i] > mins[sleepyMin] {
			sleepyMin = i
		}
	}
	sleepyMinOccu = mins[sleepyMin]

	return
}

func remapGuardNoInSlice(entries []LogEntry) []LogEntry {
	var guardNo int
	for i := 0; i < len(entries); i++ {
		if entries[i].action == BeginsShift {
			guardNo = entries[i].guardNo
		} else {
			entries[i].guardNo = guardNo
		}
	}

	return entries
}

func readLogEntries(filename string) []LogEntry {
	var entries []LogEntry

	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		entries = append(entries, NewLogEntry(scanner.Text()))
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	sort.Slice(entries, func(i, j int) bool {
		return entries[i].timestamp.Unix() < entries[j].timestamp.Unix()
	})

	return remapGuardNoInSlice(entries)
}

func logEntriesToGuards(entries []LogEntry) []*Guard {
	guards := make(map[int]*Guard)

	for _, le := range entries {
		if guard, ok := guards[le.guardNo]; ok {
			guard.entries = append(guard.entries, le)
		} else {
			guards[le.guardNo] = &Guard{le.guardNo, []LogEntry{le}}
		}
	}

	guardArr := make([]*Guard, 0, len(guards))
	for _, g := range guards {
		guardArr = append(guardArr, g)
	}

	return guardArr
}

func main() {
	entries := readLogEntries("input")
	guards := logEntriesToGuards(entries)

	parts := []struct {
		part    string
		sortFun func(int, int) bool
	}{
		{"One", func(i, j int) bool {
			giSleep, _, _ := guards[i].SleepTime()
			gjSleep, _, _ := guards[j].SleepTime()

			return giSleep > gjSleep
		}},
		{"Two", func(i, j int) bool {
			_, _, gi := guards[i].SleepTime()
			_, _, gj := guards[j].SleepTime()

			return gi > gj
		}},
	}

	for _, part := range parts {
		sort.Slice(guards, part.sortFun)

		no := guards[0].no
		_, mins, _ := guards[0].SleepTime()

		fmt.Printf("--- Part %s ---\n", part.part)
		fmt.Printf("Guard #%d sleept a lot; most at minute %d → %d\n\n",
			no, mins, no*mins)
	}
}
