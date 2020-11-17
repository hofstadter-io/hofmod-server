package client

import (
	"fmt"
	"strings"
	"time"

	"github.com/parnurzeal/gorequest"

	"{{ .ModuleImport }}/cmd/{{ .SERVER.serverName }}/flags"
	"{{ .ModuleImport }}/config"
)

func Do(args []string) (string, error) {
	var err error

	// fmt.Println("api do: ", args, flags.ApiFlags)

	req := gorequest.New()

	server := flags.ApiFlags.Server
	if server == "" {
		h, _ := config.Get("host")
		H, _ := h.String()
		p, _ := config.Get("port")
		P, _ := p.String()
		server = H + ":" + P
	}

	// parse args
	if len(args) < 2 {
		return "", fmt.Errorf("insufficient args, need to supply method and type at least")
	}

	m := strings.ToUpper(args[0])

	typ := args[1]

	url := server + "/" + typ
	if len(args) > 2 {
		 url += "/" + strings.Join(args[2:], "/")
	}

	// fmt.Println("url: ", url)

	switch m {
	case "GET", "LIST":
		req = req.Get(url)

	case "POST", "CREATE", "NEW":
		req = req.Post(url)

	case "PUT":
		req = req.Put(url)

	case "PATCH", "UPDATE":
		req = req.Patch(url)

	case "DELETE", "DEL":
		req = req.Delete(url)

	default:
		return "", fmt.Errorf("Unknown method %q", m)
	}

	req, err = setAuth(req)
	if err != nil {
		return "", err
	}

	req, err = setHeaders(req)
	if err != nil {
		return "", err
	}

	req, err = setQuery(req)
	if err != nil {
		return "", err
	}

	req, err = setTimeout(req)
	if err != nil {
		return "", err
	}

	if flags.ApiFlags.Data != "" {
		req = req.Send(flags.ApiFlags.Data)
	}

	return Finish(req)

	return "do or do not, there is no try", nil
}

func setAuth(req *gorequest.SuperAgent) (*gorequest.SuperAgent, error) {
	api := flags.ApiFlags.Apikey
	user := flags.ApiFlags.User

	if api != "" {
		req =	req.AppendHeader("apikey", api)
	} else if user != "" {
		s := strings.Split(user, ":")
		req = req.SetBasicAuth(s[0], s[1])
	}

	return req, nil
}

func setHeaders(req *gorequest.SuperAgent) (*gorequest.SuperAgent, error) {
	headers := flags.ApiFlags.Headers

	for _, h := range headers {
		H := strings.Split(h, ":")
		req = req.AppendHeader(H[0], H[1])
	}

	return req, nil
}

func setQuery(req *gorequest.SuperAgent) (*gorequest.SuperAgent, error) {
	qs := flags.ApiFlags.Headers

	for _, q := range qs {
		Q := strings.Split(q, ":")
		req = req.AppendHeader(Q[0], Q[1])
	}

	return req, nil
}

func setTimeout(req *gorequest.SuperAgent) (*gorequest.SuperAgent, error) {
	d := flags.ApiFlags.Timeout

	if d != "" {
		D, err := time.ParseDuration(d)
		if err != nil {
			return req, nil
		}

		req = req.Timeout(D)
	}

	return req, nil
}
