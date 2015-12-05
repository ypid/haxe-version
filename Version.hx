class Version {
    /**
        Return version as defined in the `haxelib.json` file. Example usage:

            Version of the suncalc library.
            public static var version(default, never):String = getVersion();
    **/
    public static macro function getVersion(filename:String = 'haxelib.json'):haxe.macro.Expr {
        var haxelib_json = haxe.Json.parse(sys.io.File.getContent(filename));
        return macro $v{haxelib_json.version};
    }

    /**
        Return the latest git commit hash. Example usage:

            git commit hash from which this library was build.
            public static var version_hash(default, never):String = getGitCommitHash();
    **/
    public static macro function getGitCommitHash():haxe.macro.Expr {
        var git_rev_parse_HEAD = new sys.io.Process('git', [ 'rev-parse', 'HEAD' ] );
        if (git_rev_parse_HEAD.exitCode() != 0) {
            throw("`git rev-parse HEAD` failed: " + git_rev_parse_HEAD.stderr.readAll().toString());
        }
        var commit_hash = git_rev_parse_HEAD.stdout.readLine();
        return macro $v{commit_hash};
    }

    /**
        Return the version of Haxe. Example usage:

            Version of Haxe used to build this library.
            public static var version_haxe_compiler(default, never):String = getHaxeCompilerVersion();
    **/
    public static macro function getHaxeCompilerVersion():haxe.macro.Expr {
        // Returns float number like: 3.201
        // var haxe_ver = haxe.macro.Context.definedValue("haxe_ver");

        var proc_haxe_version = new sys.io.Process('haxe', [ '-version' ] );
        if (proc_haxe_version.exitCode() != 0) {
            throw("`haxe -version` failed: " + proc_haxe_version.stderr.readAll().toString());
        }
        var haxe_ver = proc_haxe_version.stderr.readLine();
        return macro $v{haxe_ver};
    }
}
