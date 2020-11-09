package schema

import (
  "strings"
)

#Server: {
  Name:     string
  serverName:  strings.ToCamel(Name)
  ServerName:  strings.ToTitle(Name)
  SERVER_NAME: strings.ToUpper(Name)

	// A short description
	Description: string

  Package:  string

	AuthConfig: {
		Authentication: #Authentication
		Authorization:  #Authorization
	}

	// Rest configuration
	Rest: #Rest

	// Setup Goreleaser config
  Releases: bool | *true

	// directory of files to embed into the binary
	EmbedDir?: string

  // Debugging
  EnablePProf: bool | *false

	...
}

#HttpMethod: "OPTIONS" | "HEAD" | "GET" | "POST" | "PATCH" | "PUT" | "DELETE" | "CONNECT" | "TRACE"
