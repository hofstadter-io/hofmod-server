{{- if .tagName}}json:"{{ .tagName }}" {{else}}json:"{{ .fieldName }}" {{ end -}}
{{- if .GormTag}}{{ .GormTag }} {{ else -}}gorm:"{{- /* spacing helper */ -}}
{{- if eq .type "string"}}type:varchar({{.length}}){{ else }}type:{{ .type }}{{ end -}}
{{- if .unique }};uniqueIndex{{ else if .indexName }};index:{{ .indexName }}{{ else if .index }};index{{ end -}}
{{- if not .nullable}};not null{{ end -}}
{{- if .default}};default:{{ .default }}{{ end -}}
{{- /* spacing helper */ -}}"
{{- if .validation }} validate:"{{- /* spacing helper */ -}}
{{- $first := true}}
{{- range $K, $V := .validation -}}
{{- if not $first }},{{else}}{{ $first = false }}{{ end -}}
{{- if eq $K "min"}}min={{$V -}}
{{- else if eq $K "max"}}max={{$V -}}
{{- else if eq $K "format"}}{{$V -}}
{{- else }}{{ $K -}}
{{- end -}}
{{- end -}}
{{- /* spacing helper */ -}}"
{{- end -}}
{{- end -}}
