{lib, ...}: with lib;{packagesFromDirectoryRecursive = 
    {
      callPackage,
      directory,
      ...
    }	:
    let
      # Determine if a directory entry from `readDir` indicates a package or
      # directory of packages.
      directoryEntryIsPackage = basename: type:
        type == "directory" || hasSuffix ".nix" basename;

      # List directory entries that indicate packages in the given `path`.
      packageDirectoryEntries = path:
        filterAttrs directoryEntryIsPackage (builtins.readDir path);

      # Transform a directory entry (a `basename` and `type` pair) into a
      # package.
      directoryEntryToAttrPair = subdirectory: basename: type:
        let
          path = subdirectory + "/${basename}";
        in
        if type == "regular"
        then
        {
          name = removeSuffix ".nix" basename;
          value = callPackage path { };
        }
        else
        if type == "directory"
        then
        {
          name = basename;
          value = packagesFromDirectory path;
        }
        else
        throw
          ''
            lib.filesystem.packagesFromDirectoryRecursive: Unsupported file type ${type} at path ${toString subdirectory}
          '';

      # Transform a directory into a package but its edited to use default.nix because package.nix is nonstandard or
      # set of packages (otherwise).
      packagesFromDirectory = path:
        let
          defaultPackagePath = path + "/default.nix";
        in
        if pathExists defaultPackagePath
        then callPackage defaultPackagePath { }
        else mapAttrs'
          (directoryEntryToAttrPair path)
          (packageDirectoryEntries path);
    in
    packagesFromDirectory directory;
}
