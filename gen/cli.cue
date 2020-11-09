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

		Commands: [{
			Name: "serve"
			Short: "run the server"
			Long: Short

			Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/\(Server.serverName)"), As: "server"}]

			Body: """
			server.Run()
			"""
		},{
			Name: "db"
			Short: "work with the database"
			Long: Short

			Commands: [{
				Name: "test"
				Short: "test connecting to the db"
				Long: Short

				Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/\(Server.serverName)/db"), As: "db"}]

				Body: #DbTestBody
			},{
				Name: "migrate"
				Short: "auto-migrate the database schema"
				Long: "Auto migrates the database schema to match the latest design. Does not drop columns or delete tables."

				Imports: [{ Path: path.Clean("\(Module)/\(Outdir)/server/\(Server.serverName)/db"), As: "db"}]

				Body: #DbMigrateBody
			}]
		}]
	}
}

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

fmt.Println("Migration Completed")
"""
