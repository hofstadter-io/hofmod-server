package gen

import (
	"list"

  hof "github.com/hofstadter-io/hof/schema"

  "github.com/hofstadter-io/hofmod-server/schema"
)

#HofGenerator: hof.#HofGenerator & {
  Server: schema.#Server
  Outdir?: string | *"./"

  // Internal

  OutdirConfig: {
    CiOutdir: string | *"\(Outdir)/ci/\(In.SERVER.serverName)"
    ServerOutdir: string | *"\(Outdir)/server/\(In.SERVER.serverName)"
  }

  In: {
    SERVER: Server
  }

  basedir: "server/\(In.SERVER.serverName)"

  PackageName: "" | *"github.com/hofstadter-io/hofmod-server"

  PartialsDir:  "./partials/"
  TemplatesDir: "./templates/"

	// Actual files generated by hof, flattened into a single list
  Out: [...hof.#HofGeneratorFile] & list.FlattenN(All , 1)

  // Combine everything together and output files that might need to be generated
  All: [
   [ for _, F in OnceFiles { F } ],
   [ for _, F in L1_RestFiles { F } ],
   [ for _, F in L2_RestFiles { F } ],
   [ for _, F in L3_RestFiles { F } ],
  ]

  // Files that are not repeatedly used, they are generated once for the whole CLI
  OnceFiles: [...hof.#HofGeneratorFile] & [
    {
      TemplateName: "server.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/server.go"
    },
    {
      TemplateName: "router.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/router.go"
    },
    {
      TemplateName: "middleware.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/middleware.go"
    },
  ]

  // Sub command tree
  L1_RestFiles: [...hof.#HofGeneratorFile] & list.FlattenN([[
    for _, R in Server.Rest.Routes
    {
      In: {
        ROUTE: {
          R
          PackageName: "rest"
        }
      }
      TemplateName: "rest/handler.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/rest/\(In.ROUTE.Name).go"
		}
	]], 1)

  L2_RestRoutes: [ for P in L1_RestFiles if len(P.In.ROUTE.Routes) > 0 {
    [ for R in P.In.ROUTE.Routes { R,  Parent: { Name: P.In.ROUTE.Name } }]
  }]
  L2_RestFiles: [...hof.#HofGeneratorFile] & [ // List comprehension
    for _, R in list.FlattenN(L2_RestRoutes, 1)
    {
      In: {
        REST: R
      }
      TemplateName: "rest/handler.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/rest/\(R.Parent.Name)/\(R.Name).go"
    }
  ]

  L3_RestRoutes: [ for P in L2_RestFiles if len(P.In.ROUTE.Routes) > 0 {
    [ for R in P.In.ROUTE.Routes { R,  Parent: { Name: P.In.ROUTE.Name, Parent: P.In.ROUTE.Parent } }]
  }]
  L3_RestFiles: [...hof.#HofGeneratorFile] & [ // List comprehension
    for _, R in list.FlattenN(L3_RestRoutes, 1)
    {
      In: {
        REST: R
      }
      TemplateName: "rest/handler.go"
      Filepath: "\(OutdirConfig.ServerOutdir)/\(R.Parent.Parent.Name)/\(R.Parent.Name)/\(R.Name).go"
    }
  ]

	...
}
