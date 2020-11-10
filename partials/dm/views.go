{{ $ROOT := . }}
{{ range $i, $VIEW := .MODEL.Views }}
type {{ $ROOT.MODEL.ModelName }}{{ $VIEW.ViewName }}View struct {
	{{ range $VIEW.Fields }}
	{{ template "dm/field.go" . }}
	{{end}}
}
{{ end }}
