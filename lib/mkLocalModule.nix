{lib, config,...}: rec {
    /**
	Split a string, and return all elements after a marker.

	# Example

	```
	splitAfterMarker "/" "modules" /home/user/flake/modules/abc/def
	== ["abc" "def"]
	```
    */
    splitAfterMarker = splitter: marker: input: builtins.foldl' (acc: new:
	if acc == false then # marker not found yet
	    if new == marker then [] /* marker found */ else false
	    else acc ++ [new] # marker already found, add to output list
    ) false (lib.splitString splitter input);
    /**
	Make a Nix module, with its attrpath being the local path
	relative to a marker directory. Accepts a prefix, and removes `.nix` file endings.

	# Example

	```
	mkLocalModuleMarker "modules" ["myModules" "abc"] ./current-file.nix "enable something" {}
	{ myModules.abc.current.file.path.current-file.enable = true; }
	```
    */
    mkLocalModuleMarker = marker: prefix: currentPath: optDesc: moduleConfig: let
	normalizedPath = lib.removeSuffix ".nix" (builtins.toString currentPath);
	attrPath = prefix ++ (splitAfterMarker "/" marker normalizedPath) ++ "enable";
	mod = {
	    options = lib.setAttrsByPath attrPath (lib.mkEnableOption optDesc);
	    config = lib.mkIf (lib.getAttrFromPath attrPath config) moduleConfig;
	};
    in mod;
    /**
	Find a folder or a parent folder containing a file.

	# Example

	```
	findFolderWithFile "flake.nix" ./.
	== /home/user/flake/
	```
    */	
    findFolderWithFile = file: arg:
	if builtins.pathExists (arg + "/" + file) then arg
        else if arg == /. then throw "could not find folder containing ${file}"
	else findFolderWithFile file (arg + "/..");
    /**
	Shorthand for mkLocalModuleMarker, setting marker to your flake and prefix to l.
    */
    mkLocalModule = currentPath: mkLocalModuleMarker (findFolderWithFile "flake.nix" currentPath) ["l"] currentPath;
}

# foldl' op nul [x0 x1 x2 ...] = op (op (op nul x0) x1) x2) .... For example, foldl' (x: y: x + y) 0 [1 2 3]


# input = /home/alina/flake/desktop/common
# options.desktop.common
# input' = /nix/store/aaa-flake/desktop/common
# foldl' (split "/" input)
# marker = flake
# foldl' ([home  alina flake modules   audio.nix          ])
# acc =    false false []    [modules] [modules audio.nix]
#          |           ^ marker found
#          | marker not found yet


# $ echo "abc\ndef" > readme
# readPathsFromFile "readme" == [./abc ./def]
