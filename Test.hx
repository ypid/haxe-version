class Test {
    static function main()
    {
        trace("haxelib", Version.getVersion());
        trace("commit", Version.getGitCommitHash());
        trace("tag", Version.getGitTag());
        trace("dirty", Version.isGitTreeDirty());

        trace("incrementing");
        Version.incrementVersion();
        trace("haxelib", Version.getVersion());
        trace("dirty", Version.isGitTreeDirty());

        trace("haxe", Version.getHaxeCompilerVersion());
    }
}

