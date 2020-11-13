package mailer

import (
	"cuelang.org/go/cue"
	"github.com/mailgun/mailgun-go/v4"

	"{{ .ModuleImport }}/config"
)

var MG *mailgun.MailgunImpl

func InitMailgun() (error) {

	cfg := config.Config.LookupPath(cue.ParsePath("mailer.mailgun"))
	var V map[string]string
	err := cfg.Decode(&V)
	if err != nil {
		return err
	}

	MG = mailgun.NewMailgun(V["domain"], V["secret"])

	return nil
}
