package main

import (
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	settings, err := os.ReadFile("gnome-shell.txt")
	if err != nil {
		log.Fatalf("Error reading File: %s", err)
	}

	fields := strings.Split(string(settings), "\n")

	for _, f := range fields {
		parts := strings.Split(f, " ")
		if len(parts) < 3 {
			continue
		}
		err := exec.Command("gsettings", "set", parts[0], parts[1], parts[2]).Run()
		if err != nil {
			log.Printf("Error setting %s %s %s: %s", parts[0], parts[1], parts[2], err)
		} else {
			log.Printf("Set %s %s successfully", parts[1], parts[2])
		}
	}

}
