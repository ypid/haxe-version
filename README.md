# version library for Haxe

Haxe macros useful for including version strings (version from `haxelib.json`, git commit hash and Haxe version) to a target build.

To use it, just install it via `haxelib install version` and use the `-lib version` switch for `haxe`.

Refer to [Version.hx](/lib/Version.hx) to see which macros are available and how to use them.

Credits for the idea go to [Andy Li](https://blog.onthewings.net/) who presented a similar macro using `git describe --tags` in [Haxe, a language that compiles to JS](https://blog.onthewings.net/about/).
