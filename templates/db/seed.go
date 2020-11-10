package db

{{ $ModuleImport := .ModuleImport }}

import (
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/errors"
	"cuelang.org/go/cue/format"
	"cuelang.org/go/cue/load"
	"golang.org/x/crypto/bcrypt"
  "gorm.io/gorm"
	"github.com/hofstadter-io/hof/lib/cuetils"

	"{{ .ModuleImport }}/cmd/{{ .SERVER.serverName }}/flags"
	"{{ $ModuleImport }}/dm"
)

const BCRYPT_COST = 12

func Seed(entrypoints []string) (err error) {
	env := flags.RootPflags.Env
	if len(entrypoints) == 0 {
		entrypoints = []string{"./seeds/"}
	}

	seeds, err := loadSeeds(env, entrypoints)
	if err != nil {
		return err
	}

	// PrintSeeds(seeds)
	fmt.Println("Seeding...")

	err = clearData()
	if err != nil {
		return err
	}

	err = runSeeds(seeds)
	if err != nil {
		return err
	}

	return nil
}

func migOld(entrypoints []string) (err error) {
	DB.AutoMigrate(
	// Builtin Models
	{{ range $i, $model := .MODELS.Builtin.MigrateOrder -}}
		&dm.{{ $model.ModelName }}{},
	{{ end }}

	// User Models
	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ $MODELS := $mset.Models -}}
	{{ if $mset.MigrateOrder }}{{ $MODELS = $mset.MigrateOrder }}{{ end -}}
	{{ range $j, $model := $MODELS -}}
		&dm.{{ $model.ModelName }}{},
	{{ end }}
	{{ end }}
	)

	return nil
}

func loadSeeds(env string, entrypoints []string) (seeds cue.Value, err error) {
	var errs []error
	CueRT := &cue.Runtime{}

	BIS := load.Instances(entrypoints, &load.Config{
		Package: env,
	})
	for _, bi := range BIS {
		if bi.Err != nil {
			es := errors.Errors(bi.Err)
			for _, e := range es {
				errs = append(errs, e)
			}
			continue
		}

		I, err := CueRT.Build(bi)
		if err != nil {
			es := errors.Errors(err)
			for _, e := range es {
				errs = append(errs, e)
			}
			continue
		}

		val := I.Value()

		if !seeds.Exists() {
			seeds = val
		} else {
			seeds = seeds.Fill(val)
		}

		// TODO, validate

	}

	if len(errs) > 0 {
		for _, e := range errs {
			cuetils.PrintCueError(e)
		}
		return seeds, fmt.Errorf("Errors while reading config & secrets from %v", entrypoints)
	}

	return seeds, nil
}

func clearData() (err error) {
	sess := &gorm.Session{
		AllowGlobalUpdate: true,
	}
	{{ range $i, $model := .MODELS.Builtin.MigrateOrder -}}
	err = DB.Session(sess).Unscoped().Delete(&dm.{{ $model.ModelName }}{}).Error
	if err != nil {
		return err
	}
	{{end}}

	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ if ne $mset.ModelsetName "Builtin" }}
	{{ $MODELS := $mset.Models -}}
	{{ if $mset.MigrateOrder }}{{ $MODELS = $mset.MigrateOrder }}{{ end -}}
	{{ range $j, $model := $MODELS -}}
	err = DB.Session(sess).Unscoped().Delete(&dm.{{ $model.ModelName }}{}).Error
	if err != nil {
		return err
	}
	{{ end }}
	{{ end }}
	{{ end }}

	return nil
}

func runSeeds(seeds cue.Value) (err error) {

	{{ range $i, $model := .MODELS.Builtin.MigrateOrder -}}
	{{ if eq $model.ModelName "User" }}
	err = runSeed(seeds, &dm.{{ $model.ModelName }}{}, "{{ $model.ModelName }}", []string{"password"})
	{{ else }}
	err = runSeed(seeds, &dm.{{ $model.ModelName }}{}, "{{ $model.ModelName }}", nil)
	{{ end }}
	if err != nil {
		return err
	}
	{{ end }}

	{{ range $i, $mset := .MODELS.User.Modelsets -}}
	{{ if ne $mset.ModelsetName "Builtin" }}
	{{ $MODELS := $mset.Models -}}
	{{ if $mset.MigrateOrder }}{{ $MODELS = $mset.MigrateOrder }}{{ end -}}
	{{ range $j, $model := $MODELS -}}
	err = runSeed(seeds, &dm.{{ $model.ModelName }}{}, "{{ $model.ModelName }}", nil)
	if err != nil {
		return err
	}
	{{ end }}
	{{ end }}
	{{ end }}
	return nil
}

func runSeed(seeds cue.Value, modelType interface{}, modelName string, encryptFields []string) (err error) {
	val := seeds.Lookup(modelName)
	if val.Exists() {
		fmt.Println(" ", modelName)

		var data []map[string]interface{}
		S, err := val.Struct()

		// if err, not a struct, assume list
		if err != nil {
			err := val.Decode(&data)
			if err != nil {
				return err
			}
		} else {
			// build data list from stuct
			iter := S.Fields()
			for iter.Next() {
				var m map[string]interface{}
				v := iter.Value()
				err := v.Decode(&m)
				if err != nil {
					return err
				}
				data = append(data, m)
			}
		}

		// modify certain fields
		for i, v := range data {
			for _, F := range encryptFields {
				p, ok := v[F].(string)
				if !ok {
					return fmt.Errorf("encrypted field %q not found in %v", F, v)
				}
				P, err := bcrypt.GenerateFromPassword([]byte(p), BCRYPT_COST)
				if err != nil {
					return err
				}
				v[F] = P
				data[i] = v
			}
		}

		// fmt.Println(data)

		tx := DB.Model(modelType).Create(data)
		if tx.Error != nil {
			return tx.Error
		}
	}

	return nil
}

func PrintSeeds(seeds cue.Value) error {
	// get string version of value
	bytes, err := format.Node(seeds.Syntax())
	if err != nil {
		return err
	}

	str := string(bytes)
	fmt.Println(str)

	return nil
}
