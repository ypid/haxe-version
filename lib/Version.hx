class Version {
    /**
        Return version as defined in the `haxelib.json` file. Example usage:

            Version of the library.
            public static var version(default, never):String = Version.getVersion();
    **/
    public static macro function getVersion(filename:String = 'haxelib.json'):haxe.macro.Expr {
        var haxelib_json = haxe.Json.parse(sys.io.File.getContent(filename));
        return macro $v{haxelib_json.version};
    }

    /**
        Increment the version defined in the `haxelib.json` file. Example usage:

            Increment version in hxml
            --macro Version.incrementVersion()
    **/

    public static macro function incrementVersion(filename:String = 'haxelib.json'):haxe.macro.Expr {
        var haxelib_json = haxe.Json.parse(sys.io.File.getContent(filename));
        var result:Array<String> = haxelib_json.version.split('.');
        result[result.length-1] = cast (Std.parseInt(result[result.length-1]) + 1);
        haxelib_json.version = result.join('.');
        sys.io.File.saveContent(filename, haxe.Json.stringify(haxelib_json, null, " "));
        return macro null;
    }

    /**
        Return the latest git commit hash. Example usage:

            git commit hash from which this library was build.
            public static var version_hash(default, never):String = Version.getGitCommitHash();
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
        Return the latest git tag. Example usage:

            git tag from which this library was build.
            public static var version_tag(default, never):String = Version.getGitTag();
    **/
    public static macro function getGitTag():haxe.macro.Expr {
        var git_describe = new sys.io.Process('git', [ 'describe', '--abbrev=0', '--tags' ] );
        if (git_describe.exitCode() != 0) {
            throw("`git describe --abbrev=0 --tags` failed: " + git_describe.stderr.readAll().toString());
        }
        var tag = git_describe.stdout.readLine();
        return macro $v{tag};
    }

    /**
        Return if the git tree is dirty. Example usage:

            any changes since last commit.
            public static var version_modified(default, never):String = Version.isGitTreeDirty();
    **/
    public static macro function isGitTreeDirty():haxe.macro.Expr {
        var git_diff = new sys.io.Process('git', [ 'diff', '--quiet', 'HEAD' ] );
        var exit = git_diff.exitCode();
        return
            switch exit {
            case 0: macro false;
            case 1: macro true;
            case _: throw("`git diff --quiet HEAD` failed: " + git_diff.stderr.readAll().toString());
            }
    }

    /**
        Return the version of Haxe. Example usage:

            Version of Haxe used to build this library.
            public static var version_haxe_compiler(default, never):String = Version.getHaxeCompilerVersion();
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
