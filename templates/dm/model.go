package {{ .MODEL.PackageName }}

{{ template "dm/imports.go" . }}

{{ template "dm/type.go" . }}

{{ template "dm/views.go" . }}

