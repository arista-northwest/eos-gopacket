package main

import (
	"fmt"

	"github.com/google/gopacket/pcap"
)

func main() {
	fmt.Println(pcap.Version())
}
