{{ $name := .FieldName }}
{{ if .private }}{{ $name = .fieldName }}{{ end }}

{{ $type := (print "UNKNOWN Field type: " .type) }}
{{ if eq .type "uuid" }}{{ $type = "uuid.UUID" }}
{{ else if eq .type "string" }}{{ $type = "string" }}
{{ else if eq .type "text" }}{{ $type = "string" }}
{{ else if eq .type "bytes" }}{{ $type = "[]byte" }}
{{ else if eq .type "bool" }}{{ $type = "bool" }}
{{ else if eq .type "int" }}{{ $type = "int" }}
{{ else if eq .type "uint" }}{{ $type = "uint" }}
{{ else if eq .type "float" }}{{ $type = "float64" }}
{{ else if eq .type "duration" }}{{ $type = "time.Duration" }}
{{ else if eq .type "date" }}{{ $type = "time.Time" }}
{{ else if eq .type "time" }}{{ $type = "time.Time" }}
{{ else if eq .type "datetime" }}{{ $type = "time.Time" }}

{{ end }}
{{ if .Doc }}/* {{ .Doc }} */{{end}}
{{ $name }} {{ $type }} `{{ template "dm/tags.go" . }}`
