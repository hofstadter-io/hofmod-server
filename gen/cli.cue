package gen

import (
	"path"

  cli_g "github.com/hofstadter-io/hofmod-cli/gen"
	cli_s "github.com/hofstadter-io/hofmod-cli/schema"

  // hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#CliGen: cli_g.#HofGenerator & {
	Outdir: string
	Server: schema.#Server
	Module: string

	Cli: cli_s.#Cli & {
		Name: Server.Name
		Package: "\(Server.Package)/cmd/\(Server.serverName)"

		Usage: "\(Server.serverName)"
		Short: Server.description | "server cli"

		Updates: false

		OmitRun: true

		Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/config"), As: "config"}]
		PersistentPrerun: true
		PersistentPrerunBody: #PersistentPrerunBody

		Pflags: [{
			Name: "env"
			Long: "env"
			Short: "E"
			Type: "string"
			Default: "\"dev\""
			Help: "Environment to use, also the package from config/secret to load"
		},{
			Name: "config"
			Long: "config"
			Short: "C"
			Type: "[]string"
			Default: "[]string{\"./config\"}"
			Help: "Entrypoint(s) to Cue config(s) to use"
		},{
			Name: "secret"
			Long: "secret"
			Short: "S"
			Type: "[]string"
			Default: "[]string{\"./secret\"}"
			Help: "Entrypoint(s) to Cue secret(s) to use"
		}]

		Commands: [{
			Name: "run"
			Short: "run the server"
			Long: Short

			Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server"), As: "server"}]

			Body: """
			server.Run()
			"""
			
		},{
			Name: "config"

			Short: "view server config values"
			Long: Short

			Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/config"), As: "config"}]

			Body: """
			err = config.Print()
			"""
		},{
			Name: "db"
			Short: "work with the database"
			Long: Short

			OmitRun: true

			Commands: [{
				Name: "test"
				Short: "test connecting to the db"
				Long: Short

				Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/db"), As: "db"}]

				Body: #DbTestBody
			},{
				Name: "migrate"
				Short: "auto-migrate the database schema"
				Long: "Auto migrates the database schema to match the latest design. Does not drop columns or delete tables."

				Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/db"), As: "db"}]

				Body: #DbMigrateBody
			},{
				Name: "seed"
				Short: "seed your database"

				Long: "Seeds the database using the Cue entrypoints"

				Args: [{
					Name: "entrypoints"
					Type: "[]string"
					Rest: true
					Help: "Cue entrypoints to load seed data from. (default: './seeds/')"
				}]

				Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/db"), As: "db"}]

				Body: #DbSeedBody
			}]
		}]
	}
}

#PersistentPrerunBody: """
err = config.Load()
"""

#DbTestBody: """
err = db.OpenPostgres()
if err != nil {
	return err
}

fmt.Println("OK")
"""

#DbMigrateBody: """
err = db.OpenPostgres()
if err != nil {
	return err
}

err = db.RunMigrations()
if err != nil {
	return err
}

fmt.Println("Migration Complete")
"""

#DbSeedBody: """
err = db.OpenPostgres()
if err != nil {
	return err
}

err = db.Seed(entrypoints)
if err != nil {
	return err
}

fmt.Println("Seeding Complete")
"""
