{lib, ...}: let
  inherit (import ./packagesFromDirectoryRecursive.nix {inherit lib;}) packagesFromDirectoryRecursive;
  mapAttrKVs = mapFn: attrs: builtins.foldl' (acc: cur: acc // {${cur.key} = cur.value;}) {} (builtins.attrValues (builtins.mapAttrs mapFn attrs));
  #kv = key: value: {inherit key value;};
  recurseNaive = curPath: fn:
    mapAttrKVs (
      k: v: let
        match = builtins.match "(.*)[.]nix" k;
      in
        if v == "regular" && match != null
        then {
          key = builtins.elemAt match 0;
          value = fn (curPath + ("/" + k));
        }
        else if v == "directory"
        then {
          key = k;
          value = recurseNaive (curPath + ("/" + k)) fn;
        }
        else {
          key = null;
          value = null;
        }
    ) (builtins.readDir curPath);

  getAttrKVsRec = prefix: as:
    lib.flatten (lib.mapAttrsToList (
        k: v:
          if lib.isAttrs v
          then getAttrKVsRec (prefix ++ [k]) v
          else [
            {
              path = prefix ++ [k];
              value = v;
            }
          ]
      )
      as);

  getPathKVsRec = prefix: dir:
    getAttrKVsRec prefix (packagesFromDirectoryRecursive {
      callPackage = path: x: path;
      directory = dir;
    });

  unifyMod = (import ./modules-extracted.nix {lib = lib;}).unifyModuleSyntax;
  transformLocalMod = {
    path,
    value,
  }: let
    modFn =
      if lib.isFunction (import value)
      then import value
      else (p: import value);
    newMod = p: let
      paramNew =
        p
        // {
          cfg = lib.getAttrFromPath path p.config;
        };

      pathStr = builtins.concatStringsSep "." path;
      modRaw = modFn paramNew;
      modUni = unifyMod pathStr pathStr (builtins.removeAttrs modRaw ["opt" "mod" "srv" "ip"]);

      mod = modRaw.mod or {};
      fileCtx = str: "${modUni._file} (mkLocalMods ${str})";
      enablePath = path ++ ["enable"];
      servicePath = ["l" "srv"] ++ (builtins.head (lib.reverseList path));
      ipPath = ["l" "ip"] ++ (builtins.head (lib.reverseList path));
      optionAtLocalRoot = modRaw.opt._type == "option";
      
      imports = [
        {
          _file = fileCtx "`opt` processor";
          key = fileCtx "`opt` processor";
          options = lib.setAttrByPath path (modRaw.opt or {});
        }
        {
          _file = fileCtx "`enable` definition";
          key = fileCtx "`enable` definition";
          options = lib.mkIf 
	    !optionAtLocalRoot 
	      (lib.setAttrByPath 
	        enablePath 
	        (lib.mkEnableOption (mod.desc or mod.description or mod.name or pathStr)));
        }
        ({config, ...}: {
          _file = fileCtx "config wrapper";
          key = fileCtx "config wrapper";
          config = lib.mkIf 
	    ((lib.getAttrFromPath enablePath config) || (optionAtLocalRoot))
	    modUni.config;
        })
	{
	  _file = fileCtx "`srv` processor";
          key = fileCtx "`srv` processor";
	  config = lib.setAttrByPath servicePath (modRaw.srv or {});
	}
	{

	  _file = fileCtx "`ip` processor";
          key = fileCtx "`ip` processor";
	  config = lib.setAttrByPath ipPath (modRaw.ip or {});
	}
      ];

      newMod =
        modUni
        // {
          imports = modUni.imports ++ imports;
          config = {};
        };
    in
      newMod;
  in
    lib.mirrorFunctionArgs modFn newMod;

  mkLocalMods = {
    prefix ? [],
    dir,
  }: {
    _file = "mkLocalMods collector";
    imports = builtins.map transformLocalMod (getPathKVsRec prefix dir);
  };
in
  mkLocalMods
