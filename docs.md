## Docs

Note: the docuemntation is a WIP

### Configuration

####autoReload####
Will reload zwm on change to configuration if set to true.

####mods####
A list of modifier keys to be used in defining bindings for zwm.

// TODO: This should be an array?

To create a mod key simply suffix "mod" with a number of your choosing and then the corresponding key.

```json
...
	"mods" : {
		"mod1" : "alt" // Defines the first modifier to be alt
	}
...
```

This can then be used when defining short cuts

```json
...
	"key_bindings" : {
		"terminal" : {
			...
			"key" : "mod1-enter" // Alt-enter will open the terminal
			...
		}
	}
...

```

###key_bindings###

TODO: This should be an array?

You can create different types of keybindings which perform different tasks such as opening an application or interacting with windows.

A key binding is defined with a name, a key, a type and an action. The action could be different depending on the type.

```json
	"key_bindings" : {
		"terminal" : {
			"key" : "mod1-enter", // Alt-enter will open the terminal at the path provided
			"type" : "application",
			"action" : "/Applications/iTerm.app"
		}
	}
```


