package config

import (
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/errors"
	"cuelang.org/go/cue/format"
	"cuelang.org/go/cue/load"

	"github.com/hofstadter-io/hof/lib/cuetils"

	"{{ .ModuleImport }}/cmd/{{ .SERVER.serverName }}/flags"
)

var Config cue.Value

func Get(path string) (val cue.Value, err error) {

	r := Config.LookupPath(cue.ParsePath(path))
	if r.Err() != nil {
		return cue.Value{}, r.Err()
	}

	return r, nil
}

func Load() (err error) {
	env := flags.RootPflags.Env
	configs := flags.RootPflags.Config
	secrets := flags.RootPflags.Secret

	return loadConfig(env, append(configs, secrets...))
}

func loadConfig(env string, entrypoints []string) (err error) {

	// TODO, add schema (from embedded files) to the loading process

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
		if !Config.Exists() {
			Config = val
		} else {
			Config = Config.Fill(val)
		}

		// TODO, validate

	}

	if len(errs) > 0 {
		for _, e := range errs {
			cuetils.PrintCueError(e)
		}
		return fmt.Errorf("Errors while reading config & secrets from %v", entrypoints)
	}

	Config = Config.Lookup("Config")
	return nil
}

func Print() error {
	configs := flags.RootPflags.Config
	secrets := flags.RootPflags.Secret
	fmt.Println("Loading Config & Secrets", configs, secrets)
	// get string version of value
	bytes, err := format.Node(Config.Syntax())
	if err != nil {
		return err
	}

	str := string(bytes)
	fmt.Println(str)

	return nil
}
