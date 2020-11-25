{{ $Reln := . }}
{{ if eq $Reln.relation "BelongsTo" }}
{{ $Reln.RelnName }}ID {{ $Reln.type }} {{ if $Reln.GormTag }}`{{ $Reln.GormTag }}`{{ end }}
{{ else if eq $Reln.relation "HasOne" }}
{{ $Reln.RelnName }} {{ $Reln.type }} {{ if $Reln.GormTag }}`{{ $Reln.GormTag }}`{{ else }}`gorm:"foreignKey:{{ $Reln.foreignKey }},constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"{{end}}`
{{ else if eq $Reln.relation "HasMany" }}
{{ $Reln.RelnName }} []{{ $Reln.type }} {{ if $Reln.GormTag }}`{{ $Reln.GormTag }}`{{ else }}`gorm:"foreignKey:{{ $Reln.foreignKey}}"`{{end}}
{{ else if eq $Reln.relation "Many2Many" }}
{{ $Reln.RelnName }} []{{ $Reln.type }} {{ if $Reln.GormTag }}`{{ $Reln.GormTag }}`{{ else }}`gorm:"many2many:{{ $Reln.table }}"`{{end}}
{{ else }}
%% Unknown relation: '{{ $Reln.type }}'
{{ end }}
