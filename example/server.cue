package example

import (
	srv_s "github.com/hofstadter-io/hofmod-server/schema"
)

#Server: srv_s.#Server & {
	Name: "Example"
	Package: "github.com/hofstadter-io/hofmod-server/example"
}
