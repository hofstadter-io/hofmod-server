{{ $Reln := . }}
{{ if eq $Reln.relation "BelongsTo" }}
{{ $Reln.RelnName }}ID {{ $Reln.type }} {{ if $Reln.GormTag }}`{{ $Reln.GormTag }}`{{ end }}
{{ else if eq $Reln.relation "HasOne" }}
{{ $Reln.RelnName }} {{ $Reln.type }} `gorm:"foreignKey:{{ $Reln.foreignKey }},constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
{{ else if eq $Reln.relation "HasMany" }}
{{ $Reln.RelnName }} []{{ $Reln.type }} `gorm:"foreignKey:{{ $Reln.foreignKey}}"`
{{ else if eq $Reln.relation "Many2Many" }}
{{ $Reln.RelnName }} []{{ $Reln.type }} {{ if $Reln.table }}`gorm:"many2many:{{ $Reln.table }}"`{{end}}
{{ else }}
%% Unknown relation: '{{ $Reln.type }}'
{{ end }}
