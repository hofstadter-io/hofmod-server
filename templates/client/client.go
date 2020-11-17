package client

import (
	"errors"
	"fmt"
	"strings"

	"github.com/parnurzeal/gorequest"
)

const HTTP2_GOAWAY_CHECK = "http2: server sent GOAWAY and closed the connection"

func Finish(req *gorequest.SuperAgent) (string, error) {
	resp, body, errs := req.End()

	if len(errs) != 0 && !strings.Contains(errs[0].Error(), HTTP2_GOAWAY_CHECK) {
		fmt.Println("errs:", errs)
		fmt.Println("resp:", resp)
		fmt.Println("body:", body)
		return body, errs[0]
	}

	if len(errs) != 0 || resp.StatusCode >= 500 {
		return body, errors.New("Internal Error: " + body)
	}
	if resp.StatusCode >= 400 {
		return body, errors.New("Bad Request: " + body)
	}

	return body, nil
}
