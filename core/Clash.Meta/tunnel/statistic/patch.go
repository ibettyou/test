package statistic

import (
	C "github.com/metacubex/mihomo/constant"
)

type TrackerMetaInfo struct {
	Process     string `json:"process,omitempty"`
	ProcessPath string `json:"processPath,omitempty"`
	Host        string `json:"host,omitempty"`
	DnsMode     string `json:"dnsMode,omitempty"`
	Uid         int32  `json:"uid,omitempty"`
}

type TrackerMetaHook func(metadata *C.Metadata) *TrackerMetaInfo

var DefaultTrackerMetaHook TrackerMetaHook

