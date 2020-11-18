package mailer

{{ range $key, $val := .SERVER.EmailConfig.Content }}
const {{ $key }} = `$val`

{{ end }}
