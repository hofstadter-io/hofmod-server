{{ $name := .FieldName }}
{{ if .private }}{{ $name = .fieldName }}{{ end }}
{{ $type := (print "UNKNOWN Field type: " .type) }}

{{ if eq .type "any" }}{{ $type = "interface{}" }}
{{ else if eq .type "[any]" }}{{ $type = "[]interface{}" }}
{{ else if eq .type "{any}" }}{{ $type = "map[string]interface{}" }}

{{ else if eq .type "uuid" }}{{ $type = "uuid.UUID" }}
{{ else if eq .type "[uuid]" }}{{ $type = "[]uuid.UUID" }}
{{ else if eq .type "{uuid}" }}{{ $type = "map[string]uuid.UUID" }}

{{ else if eq .type "cuid" }}{{ $type = "cuid.CUID" }}
{{ else if eq .type "[cuid]" }}{{ $type = "[]cuid.CUID" }}
{{ else if eq .type "{cuid}" }}{{ $type = "map[string]cuid.CUID" }}

{{ else if eq .type "string" }}{{ $type = "string" }}
{{ else if eq .type "[string]" }}{{ $type = "[]string" }}
{{ else if eq .type "{string}" }}{{ $type = "map[string]string" }}

{{ else if eq .type "text" }}{{ $type = "string" }}
{{ else if eq .type "[text]" }}{{ $type = "[]string" }}
{{ else if eq .type "{text}" }}{{ $type = "map[string]string" }}

{{ else if eq .type "bytes" }}{{ $type = "[]byte" }}
{{ else if eq .type "[bytes]" }}{{ $type = "[][]byte" }}
{{ else if eq .type "{bytes}" }}{{ $type = "map[string][]byte" }}

{{ else if eq .type "bool" }}{{ $type = "bool" }}
{{ else if eq .type "[bool]" }}{{ $type = "[]bool" }}
{{ else if eq .type "{bool}" }}{{ $type = "map[string]bool" }}

{{ else if eq .type "int" }}{{ $type = "int" }}
{{ else if eq .type "[int]" }}{{ $type = "[]int" }}
{{ else if eq .type "{int}" }}{{ $type = "map[string]int" }}

{{ else if eq .type "uint" }}{{ $type = "uint" }}
{{ else if eq .type "[uint]" }}{{ $type = "[]uint" }}
{{ else if eq .type "{uint}" }}{{ $type = "map[string]uint" }}

{{ else if eq .type "float" }}{{ $type = "float64" }}
{{ else if eq .type "[float]" }}{{ $type = "[]float64" }}
{{ else if eq .type "{float}" }}{{ $type = "map[string]float64" }}

{{ else if eq .type "duration" }}{{ $type = "time.Duration" }}
{{ else if eq .type "[duration]" }}{{ $type = "[]time.Duration" }}
{{ else if eq .type "{duration}" }}{{ $type = "map[string]time.Duration" }}

{{ else if eq .type "date" }}{{ $type = "time.Time" }}
{{ else if eq .type "[date]" }}{{ $type = "[]time.Time" }}
{{ else if eq .type "{date}" }}{{ $type = "map[string]time.Time" }}

{{ else if eq .type "time" }}{{ $type = "time.Time" }}
{{ else if eq .type "[time]" }}{{ $type = "[]time.Time" }}
{{ else if eq .type "{time}" }}{{ $type = "map[string]time.Time" }}

{{ else if eq .type "datetime" }}{{ $type = "time.Time" }}
{{ else if eq .type "[datetime]" }}{{ $type = "[]time.Time" }}
{{ else if eq .type "{datetime}" }}{{ $type = "map[string]time.Time" }}

{{ end }}
{{ if .Doc }}// {{ .Doc }}{{end}}
{{ $name }} {{ $type }}
